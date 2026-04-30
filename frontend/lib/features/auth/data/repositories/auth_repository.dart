import '../models/user_model.dart';
import '../datasources/remote_auth_datasource.dart';
import '../datasources/local_auth_datasource.dart';
import '../../domain/repositories/iauth_repository.dart';
import 'package:farmlink_ug/core/domain/entities/user.dart';
import 'package:farmlink_ug/core/domain/exceptions/app_exception.dart';

/// Auth repository - implements offline-first pattern
class AuthRepository implements IAuthRepository {
  final IRemoteAuthDataSource _remoteDataSource;
  final ILocalAuthDataSource _localDataSource;

  AuthRepository({
    required IRemoteAuthDataSource remoteDataSource,
    required ILocalAuthDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<User> sendOTP(String phone) async {
    try {
      // Try remote first
      final user = await _remoteDataSource.sendOTP(phone);
      
      // Don't save yet - user hasn't verified
      return user;
    } catch (e) {
      throw e is AppException ? e : NetworkException('Send OTP failed: $e');
    }
  }

  @override
  Future<User> verifyOTP(String phone, String otp) async {
    try {
      // Verify with remote
      final user = await _remoteDataSource.verifyOTP(phone, otp);
      
      // Save locally if verified
      await _localDataSource.saveUser(user);
      
      return user;
    } catch (e) {
      throw e is AppException ? e : AuthException('Verification failed: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // Check local storage first (offline support)
      final user = await _localDataSource.getCurrentUser();
      return user;
    } catch (e) {
      throw e is AppException
          ? e
          : StorageException('Get current user failed: $e');
    }
  }

  @override
  Stream<User?> watchCurrentUser() {
    try {
      return _localDataSource.watchCurrentUser();
    } catch (e) {
      throw e is AppException
          ? e
          : StorageException('Watch user failed: $e');
    }
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? bio,
    String? profilePicture,
    String? region,
    List<String>? interests,
  }) async {
    try {
      final current = await getCurrentUser();
      if (current == null) {
        throw AuthException('No user logged in', code: 'NO_USER');
      }

      // Create updated user - ensure it's a UserModel for local storage
      final updated = (current is UserModel 
        ? current.copyWith(
            name: name,
            bio: bio,
            profilePicture: profilePicture,
            region: region,
            interests: interests,
          )
        : UserModel(
            id: current.id,
            phone: current.phone,
            name: name ?? current.name,
            profilePicture: profilePicture ?? current.profilePicture,
            bio: bio ?? current.bio,
            createdAt: current.createdAt,
            lastSignIn: current.lastSignIn,
            isLoggedIn: current.isLoggedIn,
            region: region ?? current.region,
            interests: interests ?? current.interests,
          )) as UserModel;

      // TODO: Sync to Supabase in background
      
      // Save locally
      await _localDataSource.saveUser(updated);
      
      return updated;
    } catch (e) {
      throw e is AppException ? e : StorageException('Update failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Clear local data
      await _localDataSource.deleteUser();
      
      // Sign out remotely
      await _remoteDataSource.logout();
    } catch (e) {
      throw e is AppException ? e : NetworkException('Logout failed: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final user = await getCurrentUser();
      return user != null && user.isLoggedIn;
    } catch (_) {
      return false;
    }
  }
}
