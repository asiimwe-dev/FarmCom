// ignore_for_file: unused_import, avoid_print

// import 'package:isar/isar.dart';
import '../../../core/utils/logger.dart';
import '../storage/isar_provider.dart';
import '../storage/schemas/sync_queue_schema.dart';

/// Sync worker - orchestrates offline-first sync across all features
/// Uses outbox pattern: local writes queue immediately, sync when online
/// TEMPORARY STUB: Disabled due to AGP 8.x compatibility issues
class SyncWorker {
  final dynamic _isar;

  SyncWorker(this._isar);

  /// Main sync function - called when online
  Future<void> syncAll() async {
    try {
      Logger.info('Sync disabled: Isar unavailable (AGP 8.x compatibility)');
    } catch (e) {
      Logger.error('Sync failed: $e');
    }
  }

  /// Sync individual item based on feature
  Future<void> _syncItem(dynamic item) async {
    // Stub implementation
  }

  /// Queue an item for sync
  Future<void> queueForSync({
    required String featureName,
    required String entityType,
    required String entityId,
    required String operation,
    String? payloadJson,
    String? displayName,
  }) async {
    Logger.w('Sync queue disabled: $operation $entityType ($entityId)');
  }

  /// Get pending items for a feature
  Future<List<dynamic>> getPendingForFeature(String feature) async {
    return [];
  }

  /// Clear completed syncs (optional cleanup)
  Future<void> clearCompleted() async {
    // Stub implementation
  }
}

// Initialize sync worker
SyncWorker? _syncWorker;

SyncWorker getSyncWorker() {
  _syncWorker ??= SyncWorker(null);
  return _syncWorker!;
}
