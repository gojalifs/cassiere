import 'package:cassiere/model/product.dart';
import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({Key? key}) : super(key: key);

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List<TransactionData> transactions = [];
  List<TransactionDetail> transactionDetails = [];
  List<Product> products = [];
  String report = '';
  LocalDbHelper dbHelper = LocalDbHelper();
  OnlineDbHelper onlineDbHelper = OnlineDbHelper();
  @override
  void initState() {
    // dbHelper.readMainTransaction().then((value) {
    //   setState(() {
    //     transactions = value;
    //   });
    // });
    // dbHelper.readDetailTransaction().then((value) {
    //   print('detsail transaksi $value');
    //   return transactionDetails = value;
    // });
    // dbHelper.readProducts().then((value) {
    //   setState(() {
    //     products = value;
    //   });
    //   print('product $products');
    // });
    onlineDbHelper.getTransactionDataReport().then((value) {
      setState(() {
        transactions = value;
      });
    });
    onlineDbHelper.getTransactionDetailReport().then((value) {
      setState(() {
        transactionDetails = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('id')),
                DataColumn(label: Text('Cashier')),
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Time')),
              ],
              rows: transactions.map((transaction) {
                print('eeee $transaction');
                var date = transaction.timestamp;
                return DataRow(
                  cells: [
                    DataCell(Text(transaction.transactionId.toString())),
                    DataCell(Text(transaction.cashierId)),
                    DataCell(InkWell(
                      onTap: () {
                        // var listProductNew = products.where((product) => product.id == element.productId)
                        showDialog(
                            context: context,
                            builder: (context) {
                              // var detailss = transactionDetails
                              //     .map((e) => e.productId)
                              //     .toList();
                              var detailss =
                                  transactionDetails.where((element) {
                                return element.transactionId ==
                                    transaction.transactionId;
                              }).toList();

                              return AlertDialog(
                                title: Text('Transaction Detail'),
                                actions: [
                                  ElevatedButton(
                                    child: Text('Close'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                                content: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Tansact. ID')),
                                      DataColumn(label: Text('Product ID')),
                                      DataColumn(label: Text('Product Name')),
                                      DataColumn(label: Text('Product Price')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Sub Total')),
                                    ],
                                    rows: transactionDetails
                                        .where((details) {
                                          return details.transactionId ==
                                              transaction.transactionId;
                                        })
                                        .map(
                                          (details) => DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  '${details.transactionId}')),
                                              DataCell(
                                                  Text('${details.productId}')),
                                              DataCell(Text(
                                                  '${details.productName}')),
                                              DataCell(Text(
                                                  '${details.productPrice}')),
                                              DataCell(
                                                  Text('${details.quantity}')),
                                              DataCell(
                                                  Text('${details.subTotal}')),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text('Tap me'),
                    )),
                    DataCell(Text(transaction.total.toString())),
                    DataCell(Text('${transaction.timestamp}')),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
