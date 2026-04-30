import '../models/user_model.dart';
import 'package:farmlink_ug/core/domain/exceptions/app_exception.dart';

/// Remote data source - Supabase OTP authentication
abstract class IRemoteAuthDataSource {
  Future<UserModel> sendOTP(String phone);
  Future<UserModel> verifyOTP(String phone, String otp);
  Future<void> logout();
}

class RemoteAuthDataSource implements IRemoteAuthDataSource {
  // TODO: Inject Supabase client
  // For now, mock implementation
  
  @override
  Future<UserModel> sendOTP(String phone) async {
    try {
      // TODO: Call Supabase auth.signInWithOtp(phone: phone)
      // For MVP: Just return pending user
      await Future.delayed(Duration(seconds: 1)); // Simulate API delay
      
      return UserModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        phone: phone,
        createdAt: DateTime.now(),
        isLoggedIn: false,
      );
    } catch (e) {
      throw NetworkException('Failed to send OTP: $e');
    }
  }

  @override
  Future<UserModel> verifyOTP(String phone, String otp) async {
    try {
      // TODO: Call Supabase auth.verifyOTP(phone: phone, token: otp)
      // For MVP: Mock verification
      await Future.delayed(Duration(seconds: 1));
      
      if (otp.length != 6) {
        throw AuthException('Invalid OTP', code: 'INVALID_OTP');
      }

      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phone: phone,
        createdAt: DateTime.now(),
        isLoggedIn: true,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException('Verification failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // TODO: Call Supabase auth.signOut()
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      throw NetworkException('Logout failed: $e');
    }
  }
}
