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
  @override
  void initState() {
    dbHelper.readMainTransaction().then((value) {
      setState(() {
        transactions = value;
      });
    });
    dbHelper.readDetailTransaction().then((value) {
      print('detsail transaksi $value');
      return transactionDetails = value;
    });
    super.initState();
    dbHelper.readProducts().then((value) {
      setState(() {
        products = value;
      });
      print('product $products');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      body: SizedBox.expand(
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
            rows: transactions.map((e) {
              print('eeee $e');
              var date = DateTime.fromMillisecondsSinceEpoch(e.date);
              return DataRow(
                cells: [
                  DataCell(Text(e.transactionId.toString())),
                  DataCell(Text(e.cashierId)),
                  DataCell(InkWell(
                    onTap: () {
                      // var listProductNew = products.where((product) => product.id == element.productId)
                      showDialog(
                          context: context,
                          builder: (context) {
                            // var detailss = transactionDetails
                            //     .map((e) => e.productId)
                            //     .toList();
                            var detailss = transactionDetails.where((element) {
                              return element.transactionId == e.transactionId;
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
                                      .where((element) {
                                        // var productIds = products.firstWhere(
                                        //     (product) =>
                                        //         product.id ==
                                        //         int.parse(element.productId));
                                        return int.parse(
                                                element.transactionId) ==
                                            e.transactionId;
                                        //     &&
                                        // productIds.id ==
                                        //     int.parse(element.productId
                                        //     );
                                      })
                                      .map(
                                        (details) => DataRow(
                                          cells: [
                                            DataCell(Text(
                                                '${details.transactionId}')),
                                            DataCell(
                                                Text('${details.productId}')),
                                            DataCell(Text(details.productId)),
                                            DataCell(Text(details.productId)),
                                            DataCell(Text(details.productId)),
                                            DataCell(Text(details.subTotal)),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                  // detailss
                                  //     .map((e) => DataRow(cells: [
                                  //           DataCell(Text(e.productId)),
                                  //           DataCell(Text(e.productId)),
                                  //           DataCell(Text(e.productId)),
                                  //           DataCell(Text(e.productId)),
                                  //           DataCell(Text(e.productId)),
                                  //           DataCell(Text(e.productId)),
                                  //         ]))
                                  //     .toList()
                                  // DataRow(cells:
                                  // detailss.map((e) => DataCell(Text(e.productId))).toList()
                                  // [
                                  //   DataCell(
                                  //       Text(e.transactionId.toString())),
                                  //   DataCell(Text('${productId}')),
                                  //   DataCell(Text('e.productName')),
                                  //   DataCell(Text('e.productPrice')),
                                  //   DataCell(Text('e.qty')),
                                  //   DataCell(Text('e.subTotal')),
                                  // ]
                                ),
                              ),
                            );
                          });
                    },
                    child: Text('Tap me'),
                  )),
                  DataCell(Text(e.total.toString())),
                  DataCell(
                      Text('${DateTime.fromMillisecondsSinceEpoch(e.date)}')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
