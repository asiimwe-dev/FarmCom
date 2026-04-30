import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity service to detect network status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  /// Check current connectivity status
  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

// Single instance provider - prevents duplicate listeners
final connectivityServiceProvider = Provider((ref) => ConnectivityService());

// Riverpod provider for connectivity stream
final connectivityProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

// Get current connectivity status
final isOnlineProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(connectivityServiceProvider);
  return await service.hasInternetConnection();
});
