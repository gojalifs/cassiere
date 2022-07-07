import 'dart:convert';

class TransactionData {
  String cashierId;
  String transactionDetail;
  String total;
  String cash;
  String charge;
  DateTime date;
  TransactionData({
    required this.cashierId,
    required this.transactionDetail,
    required this.total,
    required this.cash,
    required this.charge,
    required this.date,
  });

  TransactionData copyWith({
    String? cashierId,
    String? transactionDetail,
    String? total,
    String? cash,
    String? charge,
    DateTime? date,
  }) {
    return TransactionData(
      cashierId: cashierId ?? this.cashierId,
      transactionDetail: transactionDetail ?? this.transactionDetail,
      total: total ?? this.total,
      cash: cash ?? this.cash,
      charge: charge ?? this.charge,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cashierId': cashierId,
      'transactionDetail': transactionDetail,
      'total': total,
      'cash': cash,
      'charge': charge,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      cashierId: map['cashierId'] ?? '',
      transactionDetail: map['transactionDetail'] ?? '',
      total: map['total'] ?? '',
      cash: map['cash'] ?? '',
      charge: map['charge'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionData.fromJson(String source) =>
      TransactionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionData(cashierId: $cashierId, transactionDetail: $transactionDetail, total: $total, cash: $cash, charge: $charge, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionData &&
        other.cashierId == cashierId &&
        other.transactionDetail == transactionDetail &&
        other.total == total &&
        other.cash == cash &&
        other.charge == charge &&
        other.date == date;
  }

  @override
  int get hashCode {
    return cashierId.hashCode ^
        transactionDetail.hashCode ^
        total.hashCode ^
        cash.hashCode ^
        charge.hashCode ^
        date.hashCode;
  }
}

class TransactionDetail {
  String productName;
  String quantity;
  String productPrice;
  String subTotal;
  TransactionDetail({
    required this.productName,
    required this.quantity,
    required this.productPrice,
    required this.subTotal,
  });

  TransactionDetail copyWith({
    String? productName,
    String? quantity,
    String? productPrice,
    String? subTotal,
  }) {
    return TransactionDetail(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      productPrice: productPrice ?? this.productPrice,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'productPrice': productPrice,
      'subTotal': subTotal,
    };
  }

  factory TransactionDetail.fromMap(Map<String, dynamic> map) {
    return TransactionDetail(
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? '',
      productPrice: map['productPrice'] ?? '',
      subTotal: map['subTotal'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionDetail.fromJson(String source) =>
      TransactionDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionDetail(productName: $productName, quantity: $quantity, productPrice: $productPrice, subTotal: $subTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionDetail &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.productPrice == productPrice &&
        other.subTotal == subTotal;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
        quantity.hashCode ^
        productPrice.hashCode ^
        subTotal.hashCode;
  }
}
