import '../entities/transaction.dart';

/// Payment repository contract
/// Implemented by features/payments/data/repositories/payment_repository.dart
abstract class IPaymentRepository {
  /// Initialize mobile money payment
  /// Returns transaction that is pending verification
  Future<Transaction> initializeMobileMoneyPayment({
    required double amount,
    required String currency,
    required String phoneNumber,
    required String? expertId, // For expert consulting payments
    required String description,
  });

  /// Verify payment status
  /// Called after user completes payment at provider (MTN, Airtel)
  Future<Transaction> verifyPaymentStatus(String reference);

  /// Get transaction history
  Future<List<Transaction>> getTransactionHistory({
    int page = 1,
    int pageSize = 20,
  });

  /// Watch transaction history stream
  Stream<List<Transaction>> watchTransactionHistory();

  /// Get single transaction details
  Future<Transaction?> getTransaction(String transactionId);

  /// Refund a transaction
  Future<Transaction> refundTransaction({
    required String transactionId,
    String? reason,
  });

  /// Initialize escrow deal (for expert consulting)
  Future<EscrowDeal> initializeEscrow({
    required String expertId,
    required double amount,
    required String currency,
    required String serviceDescription,
  });

  /// Release escrow to expert after service completion
  Future<void> releaseEscrow(String escrowDealId);

  /// Cancel escrow and refund farmer
  Future<void> cancelEscrow(String escrowDealId);

  /// Get pending payments (not yet synced)
  Future<List<Transaction>> getPendingTransactions();

  /// Sync pending payments
  Future<void> syncPendingTransactions();

  /// Get wallet balance (cached from last sync)
  Future<double?> getWalletBalance();

  /// Watch wallet balance stream
  Stream<double?> watchWalletBalance();
}

/// Escrow deal for expert consulting
class EscrowDeal {
  final String id;
  final String farmerId;
  final String expertId;
  final double amount;
  final String currency;
  final String serviceDescription;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? releasedAt;
  final EscrowStatus status;
  final String? review;
  final int? rating; // 1-5

  EscrowDeal({
    required this.id,
    required this.farmerId,
    required this.expertId,
    required this.amount,
    required this.currency,
    required this.serviceDescription,
    required this.createdAt,
    this.completedAt,
    this.releasedAt,
    this.status = EscrowStatus.active,
    this.review,
    this.rating,
  });
}

enum EscrowStatus {
  active, // Farmer has funded
  disputed, // Disagreement between parties
  completed, // Expert marked as done
  released, // Funds released to expert
  cancelled, // Refunded to farmer
}
