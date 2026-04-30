import 'package:farmlink_ug/core/domain/repositories/ipayment_repository.dart';
import 'package:farmlink_ug/core/domain/entities/transaction.dart';
import 'package:farmlink_ug/core/utils/logger.dart';

class PaymentRepository implements IPaymentRepository {
  @override
  Future<Transaction> initializeMobileMoneyPayment({
    required double amount,
    required String currency,
    required String phoneNumber,
    required String? expertId,
    required String description,
  }) async {
    Logger.warning('Payments feature not yet implemented: initializeMobileMoneyPayment');
    throw UnimplementedError('Mobile money payments not yet implemented. Get Flutterwave credentials to enable.');
  }
  
  @override
  Future<Transaction> verifyPaymentStatus(String reference) async {
    Logger.warning('Payments feature not yet implemented: verifyPaymentStatus');
    throw UnimplementedError('Payment verification not yet implemented');
  }
  
  @override
  Future<List<Transaction>> getTransactionHistory({int page = 1, int pageSize = 20}) async {
    Logger.warning('Payments feature not yet implemented: getTransactionHistory');
    return [];
  }
  
  @override
  Stream<List<Transaction>> watchTransactionHistory() async* {
    Logger.warning('Payments feature not yet implemented: watchTransactionHistory');
    yield [];
  }
  
  @override
  Future<Transaction?> getTransaction(String transactionId) async {
    Logger.warning('Payments feature not yet implemented: getTransaction');
    return null;
  }
  
  @override
  Future<Transaction> refundTransaction({required String transactionId, String? reason}) async {
    Logger.warning('Payments feature not yet implemented: refundTransaction');
    throw UnimplementedError('Transaction refunds not yet implemented');
  }
  
  @override
  Future<EscrowDeal> initializeEscrow({required String expertId, required double amount, required String currency, required String serviceDescription}) async {
    Logger.warning('Payments feature not yet implemented: initializeEscrow');
    throw UnimplementedError('Escrow services not yet implemented');
  }
  
  @override
  Future<void> releaseEscrow(String escrowDealId) async {
    Logger.warning('Payments feature not yet implemented: releaseEscrow');
    // TODO: Implement
  }
  
  @override
  Future<void> cancelEscrow(String escrowDealId) async {
    Logger.warning('Payments feature not yet implemented: cancelEscrow');
    // TODO: Implement
  }
  
  @override
  Future<List<Transaction>> getPendingTransactions() async {
    Logger.warning('Payments feature not yet implemented: getPendingTransactions');
    return [];
  }
  
  @override
  Future<void> syncPendingTransactions() async {
    Logger.warning('Payments feature not yet implemented: syncPendingTransactions');
    // TODO: Implement
  }
  
  @override
  Future<double?> getWalletBalance() async {
    Logger.warning('Payments feature not yet implemented: getWalletBalance');
    return 0.0;
  }
  
  @override
  Stream<double?> watchWalletBalance() async* {
    Logger.warning('Payments feature not yet implemented: watchWalletBalance');
    yield 0.0;
  }
}
