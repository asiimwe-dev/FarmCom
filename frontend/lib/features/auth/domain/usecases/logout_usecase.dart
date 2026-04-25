import '../repositories/iauth_repository.dart';

/// Auth use case: Logout
class LogoutUseCase {
  final IAuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}
