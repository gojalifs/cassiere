import 'package:cassiere/pages/employees_page.dart';
import 'package:cassiere/pages/invoice_page.dart';
import 'package:cassiere/pages/login_page.dart';
import 'package:cassiere/pages/payment_page.dart';
import 'package:cassiere/pages/report_page.dart';
import 'package:cassiere/pages/product_page.dart';
import 'package:cassiere/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isAdmin}) : super(key: key);
  final bool isAdmin;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Prefs prefs = Prefs();
  final List<String> _menu = ['New Payment', 'Print Invoice', 'Sales Report'];
  final List<String> _adminMenu = ['Stocks', 'Employees'];

  String user = '';
  @override
  void initState() {
    prefs.getName().then((value) => user = value);
    super.initState();
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
                () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                }();
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
                  widget.isAdmin ? _adminMenu.length : _menu.length,
                  (index) => InkWell(
                    onTap: (() {
                      if (widget.isAdmin) {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NewProductPage(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployeesPage(),
                            ),
                          );
                        }
                      } else {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentPage(),
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
                      }
                    }),
                    child: Card(
                      color: Colors.amber,
                      child: Center(
                        child: Text(
                          widget.isAdmin ? _adminMenu[index] : _menu[index],
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
