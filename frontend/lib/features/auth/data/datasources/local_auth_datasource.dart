// ignore_for_file: unused_import

// import 'package:isar/isar.dart';
import '../models/user_model.dart';
import 'package:farmcom/core/infrastructure/storage/isar_provider.dart';
import 'package:farmcom/core/infrastructure/storage/schemas/user_schema.dart';
import 'package:farmcom/core/domain/exceptions/app_exception.dart';

/// Local data source - Isar database (Stub: Disabled for AGP 8.x compatibility)
abstract class ILocalAuthDataSource {
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> watchCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
}

class LocalAuthDataSource implements ILocalAuthDataSource {
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Stub: Isar disabled
      return null;
    } catch (e) {
      throw StorageException('Failed to get current user: $e');
    }
  }

  @override
  Stream<UserModel?> watchCurrentUser() {
    try {
      // Stub: Isar disabled
      return Stream.value(null);
    } catch (e) {
      throw StorageException('Failed to watch user: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      // Stub: Isar disabled
    } catch (e) {
      throw StorageException('Failed to save user: $e');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      // Stub: Isar disabled
    } catch (e) {
      throw StorageException('Failed to delete user: $e');
    }
  }
}
