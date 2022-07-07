import 'package:cassiere/pages/employees_page.dart';
import 'package:cassiere/pages/invoice_page.dart';
import 'package:cassiere/pages/login_page.dart';
import 'package:cassiere/pages/payment_page.dart';
import 'package:cassiere/pages/report_page.dart';
import 'package:cassiere/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.users}) : super(key: key);
  final String users;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _menu = ['New Payment', 'Print Invoice', 'Sales Report'];
  final List<String> _adminMenu = ['Update Stock', 'Update Employee'];

  String user = '';
  @override
  void initState() {
    getName();
    super.initState();
  }

  getName() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('name')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CASSIERE'),
          leading: Image.asset('assets/images/cassiere_logo.png'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) {
                  return const LoginPage();
                }), (route) => false);
              },
              icon: const Icon(
                Icons.logout_sharp,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Text('Welcome $user'),
            SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: List.generate(
                  widget.users == 'true' ? _adminMenu.length : _menu.length,
                  (index) => InkWell(
                    onTap: (() {
                      if (widget.users == 'false') {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentPage(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InvoicePage(),
                            ),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SalesReportPage(),
                            ),
                          );
                        }
                      } else {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  // const UpdateStock(),
                                  const NewProductPage(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeesPage(),
                            ),
                          );
                        }
                      }
                    }),
                    child: Card(
                      color: Colors.amber,
                      child: Center(
                        child: Text(
                          widget.users == 'true'
                              ? _adminMenu[index]
                              : _menu[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
