import 'package:cassiere/model/user.dart';
import 'package:cassiere/pages/employees_page.dart';
import 'package:cassiere/pages/invoice_page.dart';
import 'package:cassiere/pages/login_page.dart';
import 'package:cassiere/pages/payment_page.dart';
import 'package:cassiere/pages/report_page.dart';
import 'package:cassiere/pages/product/product_page.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:cassiere/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OnlineDbHelper onlineDbHelper = OnlineDbHelper();
  Prefs prefs = Prefs();
  final List<String> _menu = ['New Payment', 'Print Invoice', 'Sales Report'];
  final List<String> _adminMenu = ['Store Info', 'Stocks', 'Employees'];

  List<User> users = [];

  String user = '';
  bool isAdmin = false;

  @override
  void initState() {
    prefs.getName().then((value) => user = value);

    super.initState();
  }

  Future getUserStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('name') ?? '';
    isAdmin = prefs.getBool('isAdmin') ?? false;
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
        body: FutureBuilder(
          future:
              Future.delayed(const Duration(seconds: 2)).then((value) async {
            getUserStatus();
          }),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
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
                        isAdmin ? _adminMenu.length : _menu.length,
                        (index) => InkWell(
                          onTap: (() {
                            if (isAdmin) {
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
                                isAdmin ? _adminMenu[index] : _menu[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
