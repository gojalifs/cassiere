import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({Key? key}) : super(key: key);

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List reports = [];
  String report = '';
  DbHelper dbHelper = DbHelper();
  @override
  void initState() {
    dbHelper.readTransaction().then((value) {
      setState(() {
        reports = value;
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
      body: DataTable(
        columns: const [
          DataColumn(label: Text('id')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Total')),
        ],
        rows: reports
            .map((e) => DataRow(
                  cells: [
                    DataCell(Text(e['transactionId'].toString())),
                    DataCell(Text(e['cashierId'])),
                    DataCell(Text(e['total'].toString())),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
