import 'dart:convert';

import 'package:flutter/foundation.dart';

class TransactionData {
  String cashierId;
  int? transactionId;
  String total;
  String cash;
  String charge;
  String timestamp;
  TransactionData({
    required this.cashierId,
    this.transactionId,
    required this.total,
    required this.cash,
    required this.charge,
    required this.timestamp,
  });

  TransactionData copyWith({
    String? cashierId,
    int? transactionId,
    String? total,
    String? cash,
    String? charge,
    String? timestamp,
  }) {
    return TransactionData(
      cashierId: cashierId ?? this.cashierId,
      transactionId: transactionId ?? this.transactionId,
      total: total ?? this.total,
      cash: cash ?? this.cash,
      charge: charge ?? this.charge,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cashierId': cashierId,
      'transactionId': transactionId,
      'total': total,
      'cash': cash,
      'charge': charge,
      'timestamp': timestamp,
    };
  }

  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      cashierId: map['cashier'] ?? '',
      transactionId: int.parse(map['main_transaction_id']),
      total: map['total'] ?? '',
      cash: map['cash'] ?? '',
      charge: map['charge'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionData.fromJson(String source) =>
      TransactionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionData(cashierId: $cashierId, transactionId: $transactionId, total: $total, cash: $cash, charge: $charge, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionData &&
        other.cashierId == cashierId &&
        other.transactionId == transactionId &&
        other.total == total &&
        other.cash == cash &&
        other.charge == charge &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return cashierId.hashCode ^
        transactionId.hashCode ^
        total.hashCode ^
        cash.hashCode ^
        charge.hashCode ^
        timestamp.hashCode;
  }
}

class TransactionDetail {
  int transactionId;
  int productId;
  String? productName;
  String? productPrice;
  int quantity;
  int subTotal;
  TransactionDetail({
    required this.transactionId,
    required this.productId,
    this.productName,
    this.productPrice,
    required this.quantity,
    required this.subTotal,
  });

  TransactionDetail copyWith({
    int? transactionId,
    int? productId,
    String? productName,
    String? productPrice,
    int? quantity,
    int? subTotal,
  }) {
    return TransactionDetail(
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'subTotal': subTotal,
    };
  }

  factory TransactionDetail.fromMap(Map<String, dynamic> map) {
    return TransactionDetail(
      transactionId: int.parse(map['main_transaction_id']),
      productId: int.parse(map['product_id']),
      productName: map['productname'],
      productPrice: map['price'],
      quantity: int.parse(map['quantity']),
      subTotal: int.parse(map['subtotal']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionDetail.fromJson(String source) =>
      TransactionDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionDetail(transactionId: $transactionId, productId: $productId, productName: $productName, productPrice: $productPrice, quantity: $quantity, subTotal: $subTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionDetail &&
        other.transactionId == transactionId &&
        other.productId == productId &&
        other.productName == productName &&
        other.productPrice == productPrice &&
        other.quantity == quantity &&
        other.subTotal == subTotal;
  }

  @override
  int get hashCode {
    return transactionId.hashCode ^
        productId.hashCode ^
        productName.hashCode ^
        productPrice.hashCode ^
        quantity.hashCode ^
        subTotal.hashCode;
  }
}
