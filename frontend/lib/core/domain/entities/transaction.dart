import 'package:equatable/equatable.dart';

/// Payment transaction entity - represents money movement in FarmLink UG
class Transaction extends Equatable {
  final String id;
  final String userId;
  final String? expertId; // For expert consulting payments
  final double amount;
  final String currency; // UGX, USD
  final TransactionType type; // payment, refund, withdrawal
  final TransactionStatus status;
  final String paymentMethod; // momo, card, bank
  final String? reference; // Flutterwave reference
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata; // Additional data

  const Transaction({
    required this.id,
    required this.userId,
    this.expertId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.status,
    required this.paymentMethod,
    this.reference,
    this.description,
    required this.createdAt,
    this.completedAt,
    this.metadata,
  });

  /// Copy with modifications
  Transaction copyWith({
    String? id,
    String? userId,
    String? expertId,
    double? amount,
    String? currency,
    TransactionType? type,
    TransactionStatus? status,
    String? paymentMethod,
    String? reference,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      expertId: expertId ?? this.expertId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        expertId,
        amount,
        currency,
        type,
        status,
        paymentMethod,
        reference,
        description,
        createdAt,
        completedAt,
        metadata,
      ];
}

enum TransactionType {
  payment,
  refund,
  withdrawal,
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}
