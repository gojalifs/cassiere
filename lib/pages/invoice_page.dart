import 'dart:convert';

import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              OnlineDbHelper onlineDbHelper = OnlineDbHelper();
              onlineDbHelper
                  .getTransactionReport()
                  .then((value) => print(value));
              // List<TransactionData> transactions = [];
              // String listA =
              //     '[{transaction_id: 12, product_id: 1, product_name: ABC, product_price: 8000, qty: 1, sub_total: 8000, date: 2022-07-10 00:11:34}, {transaction_id: 12, product_id: 2, product_name: Champ, product_price: 18000, qty: 2, sub_total: 44000, date: 2022-07-10 00:11:37}, {transaction_id: 12, product_id: 1, product_name: ABC, product_price: 8000, qty: 3, sub_total: 68000, date: 2022-07-10 00:11:41}]';
              // // var a = jsonDecode(listA);
              // // print(jsonDecode(listA)); // print one

              // String listB = 'one,two,three,four';
              // var b = (listB.split(','));
              // // print(b[0]); // print one
              // LocalDbHelper dbHelper = LocalDbHelper();
              // // List<TransactionData> transactionData = [];
              // // dbHelper.clearTransactions();
              // dbHelper.readMainTransaction().then((value) {
              //   print(value);
              //   // var a = value[0]['date'];
              //   // print(value.map((e) => TransactionData.fromMap(e)));
              //   // transactions =
              //   //     value.map((e) => TransactionData.fromMap(e)).toList();

              //   // print(
              //   //     'list b ${transactionData.map((e) => e.transactionDetail).toList()}');
              //   print('last ${value.last}');
              //   // print(DateTime.fromMillisecondsSinceEpoch(int.parse(a))
              //   //     .toString()
              //   //     .runtimeType);
              // });
              // dbHelper.readDetailTransaction().then((value) {
              //   print('detail $value');
              // });
            },
            child: Text('Clear Transaction')),
      ),
    );
  }
}
