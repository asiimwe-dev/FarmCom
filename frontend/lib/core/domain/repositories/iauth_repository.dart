import '../entities/user.dart';

/// Authentication repository contract
/// Implemented by features/auth/data/repositories/auth_repository.dart
abstract class IAuthRepository {
  /// Send OTP to phone number
  /// Returns User with session token
  Future<User> sendOTP(String phone);

  /// Verify OTP and log in
  Future<User> verifyOTP(String phone, String otp);

  /// Get current logged-in user
  Future<User?> getCurrentUser();

  /// Watch current user changes (stream for reactive UI)
  Stream<User?> watchCurrentUser();

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? bio,
    String? profilePicture,
    String? region,
    List<String>? interests,
  });

  /// Logout user
  Future<void> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
