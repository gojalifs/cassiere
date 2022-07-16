import 'dart:convert';

import 'package:flutter/foundation.dart';

class TransactionData {
  String cashierId;
  int? transactionId;
  String total;
  String cash;
  String charge;
  int date;
  TransactionData({
    required this.cashierId,
    this.transactionId,
    required this.total,
    required this.cash,
    required this.charge,
    required this.date,
  });

  TransactionData copyWith({
    String? cashierId,
    int? transactionId,
    String? total,
    String? cash,
    String? charge,
    int? date,
  }) {
    return TransactionData(
      cashierId: cashierId ?? this.cashierId,
      transactionId: transactionId ?? this.transactionId,
      total: total ?? this.total,
      cash: cash ?? this.cash,
      charge: charge ?? this.charge,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cashierId': cashierId,
      'transactionId': transactionId,
      'total': total,
      'cash': cash,
      'charge': charge,
      'date': date,
    };
  }

  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      cashierId: map['cashierId'] ?? '',
      transactionId: map['transactionId'],
      total: map['total'] ?? '',
      cash: map['cash'] ?? '',
      charge: map['charge'] ?? '',
      date: int.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionData.fromJson(String source) =>
      TransactionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionData(cashierId: $cashierId, transactionId: $transactionId, total: $total, cash: $cash, charge: $charge, date: $date)';
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
        other.date == date;
  }

  @override
  int get hashCode {
    return cashierId.hashCode ^
        transactionId.hashCode ^
        total.hashCode ^
        cash.hashCode ^
        charge.hashCode ^
        date.hashCode;
  }
}

class TransactionDetail {
  String transactionId;
  String productId;
  String productName;
  String productPrice;
  String quantity;
  String subTotal;
  TransactionDetail({
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.subTotal,
  });

  TransactionDetail copyWith({
    String? transactionId,
    String? productId,
    String? productName,
    String? productPrice,
    String? quantity,
    String? subTotal,
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
      transactionId: map['transactionId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? '',
      quantity: map['quantity'] ?? '',
      subTotal: map['subTotal'] ?? '',
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
