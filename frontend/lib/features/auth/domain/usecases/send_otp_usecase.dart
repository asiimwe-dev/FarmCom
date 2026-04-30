import 'package:farmlink_ug/core/domain/entities/user.dart';
import 'package:farmlink_ug/core/domain/exceptions/app_exception.dart';
import '../repositories/iauth_repository.dart';

/// Auth use case: Send OTP to phone
class SendOTPUseCase {
  final IAuthRepository repository;

  SendOTPUseCase(this.repository);

  Future<User> call(String phone) async {
    // Validate phone
    if (phone.isEmpty || !_isValidPhone(phone)) {
      throw ValidationException(
        'Invalid phone number format',
        code: 'INVALID_PHONE',
      );
    }

    try {
      return await repository.sendOTP(phone);
    } catch (e, st) {
      throw _handleException(e, st);
    }
  }

  bool _isValidPhone(String phone) {
    // Uganda phone: +256700123456 or 0700123456
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    return cleanPhone.length >= 10 && cleanPhone.length <= 13;
  }

  AppException _handleException(Object e, StackTrace st) {
    if (e is AppException) return e;
    return UnknownException(
      'Failed to send OTP: ${e.toString()}',
      stackTrace: st,
    );
  }
}
