import 'package:farmcom/core/domain/entities/user.dart';
import 'package:farmcom/core/domain/exceptions/app_exception.dart';
import '../repositories/iauth_repository.dart';

/// Auth use case: Verify OTP and log in
class VerifyOTPUseCase {
  final IAuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<User> call(String phone, String otp) async {
    // Validate inputs
    if (phone.isEmpty || otp.isEmpty) {
      throw ValidationException(
        'Phone and OTP cannot be empty',
        code: 'INVALID_INPUT',
      );
    }

    if (otp.length != 6 || !_isNumeric(otp)) {
      throw ValidationException(
        'OTP must be 6 digits',
        code: 'INVALID_OTP_FORMAT',
      );
    }

    try {
      final user = await repository.verifyOTP(phone, otp);
      
      if (!user.isLoggedIn) {
        throw AuthException(
          'Login failed. Please try again.',
          code: 'LOGIN_FAILED',
        );
      }
      
      return user;
    } catch (e, st) {
      throw _handleException(e, st);
    }
  }

  bool _isNumeric(String s) => int.tryParse(s) != null;

  AppException _handleException(Object e, StackTrace st) {
    if (e is AppException) return e;
    return UnknownException(
      'Verification failed: ${e.toString()}',
      stackTrace: st,
    );
  }
}
