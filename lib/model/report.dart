import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cassiere/model/transaction.dart';

class TransactionReport {
  List<TransactionData> transactionData;
  List<TransactionDetail> transactionDetail;
  TransactionReport({
    required this.transactionData,
    required this.transactionDetail,
  });

  TransactionReport copyWith({
    List<TransactionData>? transactionData,
    List<TransactionDetail>? transactionDetail,
  }) {
    return TransactionReport(
      transactionData: transactionData ?? this.transactionData,
      transactionDetail: transactionDetail ?? this.transactionDetail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionData': transactionData.map((x) => x.toMap()).toList(),
      'transactionDetail': transactionDetail.map((x) => x.toMap()).toList(),
    };
  }

  factory TransactionReport.fromMap(Map<String, dynamic> map) {
    return TransactionReport(
      transactionData: List<TransactionData>.from(
          map['transactionData']?.map((x) => TransactionData.fromMap(x))),
      transactionDetail: List<TransactionDetail>.from(
          map['transactionDetail']?.map((x) => TransactionDetail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionReport.fromJson(String source) =>
      TransactionReport.fromMap(json.decode(source));

  @override
  String toString() =>
      'TransactionReport(transactionData: $transactionData, transactionDetail: $transactionDetail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionReport &&
        listEquals(other.transactionData, transactionData) &&
        listEquals(other.transactionDetail, transactionDetail);
  }

  @override
  int get hashCode => transactionData.hashCode ^ transactionDetail.hashCode;
}
