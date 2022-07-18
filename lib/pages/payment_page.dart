import 'package:cassiere/model/product.dart';
import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/library/custom_text_field.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();
  final _amountKey = GlobalKey<FormState>();
  final _productKey = GlobalKey<FormState>();
  LocalDbHelper dbHelper = LocalDbHelper();
  OnlineDbHelper onlineDbHelper = OnlineDbHelper();
  String cashier = '';
  List<Product> products = [];
  List<Map<String, dynamic>> orderList = [];
  int qty = 1;
  int productId = 0;
  int subTotal = 0;
  int total = 0;
  int charge = 0;
  int transactionId = 1;

  List<Map<String, dynamic>> transactionDetailList = [];

  @override
  void initState() {
    getCashier();
    onlineDbHelper.readLastTransaction().then((value) {
      setState(() {
        transactionId = value + 1;
        print(transactionId);
      });
    }).catchError((e) {
      if (e == null) {
        setState(() {
          transactionId = 1;
        });
      } else {
        print(e);
      }
    });
    // dbHelper.readProducts().then((value) {
    //   setState(() {
    //     products = value;
    //   });
    // });

    // dbHelper.readMainTransaction().then((value) {
    //   print(value.length);
    //   setState(() {
    //     value.isEmpty
    //         ? transactionId = 1
    //         : transactionId = value.last.transactionId! + 1;
    //   });
    //   print('id $transactionId');
    // });
    onlineDbHelper.readProduct().then((value) => setState(() {
          products = value;
        }));
    super.initState();
  }

  Future getCashier() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cashier = prefs.getString('name') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Payment'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cashier',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        cashier,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _productKey,
                    child: Column(
                      children: [
                        DropdownSearch(
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Select Product',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null) {
                              return 'Please select';
                            }
                            return null;
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          items: products.map((e) => e.name).toList(),
                          onChanged: (value) {
                            setState(() {
                              productId = products
                                  .firstWhere((e) => e.name == value)
                                  .id!;
                              _productIdController.text = productId.toString();
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          label: 'Product ID',
                          hint: 'Type/Scan Product ID',
                          controller: _productIdController,
                          onChanged: (value) {
                            productId = int.parse(_productIdController.text);
                          },
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            print('submitted');
                            // if (_productKey.currentState!.validate()) {
                            //   setState(() {
                            //     orderList.add({
                            //       'productId': productId,
                            //       'productName': products
                            //           .firstWhere((e) => e.id == productId)
                            //           .name,
                            //       'productPrice': products
                            //           .firstWhere((e) => e.id == productId)
                            //           .price,
                            //       'qty': qty,
                            //     });
                            //     subTotal = orderList
                            //         .map((e) =>
                            //             e['qty'] * int.parse(e['productPrice']))
                            //         .reduce((e, f) => e + f);
                            //     total = orderList
                            //         .map((e) =>
                            //             e['qty'] * int.parse(e['productPrice']))
                            //         .reduce((e, f) => e + f);
                            //   });
                            //   transactionData = {
                            //     'cashier_id': 'Fajar',
                            //     'transaction_detail': orderList.toString(),
                            //     'total': total.toString(),
                            //     'cash': _amountController.text,
                            //     'charge': charge.toString(),
                            //     'date': DateTime.now().millisecondsSinceEpoch
                            //   };
                            //   transactionDetailData = {
                            //     'transaction_id': '',
                            //     'product_id': productId,
                            //     'product_name': products
                            //         .firstWhere((e) => e.id == productId)
                            //         .name,
                            //     'product_price': products
                            //         .firstWhere((e) => e.id == productId)
                            //         .price,
                            //     'qty': qty,
                            //     'sub_total': subTotal,
                            //   };
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                          flex: 2,
                          child: Text(
                            'Quantity',
                          )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (qty > 0) {
                                      qty--;
                                    }
                                  });
                                },
                                icon: const Icon(
                                    Icons.remove_circle_outline_sharp),
                                iconSize: 30),
                            Text(
                              qty.toString(),
                              style: const TextStyle(fontSize: 25),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  qty++;
                                });
                              },
                              icon:
                                  const Icon(Icons.add_circle_outline_rounded),
                              iconSize: 30,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_productKey.currentState!.validate()) {
                          setState(() {
                            orderList.add({
                              'productId': productId,
                              'productName': products
                                  .firstWhere((e) => e.id == productId)
                                  .name,
                              'productPrice': products
                                  .firstWhere((e) => e.id == productId)
                                  .price,
                              'qty': qty,
                            });
                            // subTotal = orderList
                            //     .map((e) =>
                            //         e['qty'] * int.parse(e['productPrice']))
                            //     .reduce((e, f) => e + f);
                            subTotal = qty *
                                int.parse(products
                                    .firstWhere((e) => e.id == productId)
                                    .price);
                            total = orderList
                                .map((e) =>
                                    e['qty'] * int.parse(e['productPrice']))
                                .reduce((e, f) => e + f);
                          });

                          // print(productList);
                          // transactionDetailData = {
                          //   'transactionId': transactionId.toString(),
                          //   'productId': productId,
                          //   'quantity': qty.toString(),
                          //   'subTotal': subTotal.toString(),
                          // };
                          // TransactionDetail.fromMap(transactionDetailData);
                          // transactionDetailList.add(
                          //     TransactionDetail.fromMap(transactionDetailData));
                          transactionDetailList.add(TransactionDetail(
                                  transactionId: transactionId,
                                  productId: productId,
                                  quantity: qty,
                                  subTotal: subTotal)
                              .toMap());
                          print(transactionDetailList);
                        }
                      },
                      child: const Text('Add to Order List'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 2,
                    height: 5,
                  ),
                  const Divider(
                    thickness: 2,
                    height: 5,
                  ),
                  const SizedBox(height: 5),
                  OrderDetailList(orderList: orderList),
                  const Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      const Expanded(flex: 2, child: Text('Total')),
                      // const Expanded(flex: 1, child: Text('Rp')),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text('Rp '),
                            Text(
                              orderList.isEmpty
                                  ? 'Rp0'
                                  : '${orderList.map((e) => e['qty'] * int.parse(e['productPrice'])).reduce((e, f) => e + f)}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(flex: 2, child: Text('Pay by Cust')),
                      Expanded(
                        flex: 1,
                        child: Form(
                          key: _amountKey,
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (charge < 0 ||
                                  _amountController.text.isEmpty) {
                                return 'You Need More Money \$\$';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              print(_amountController.text);
                              if (_amountController.text.isEmpty) {
                                setState(() {
                                  charge = 0;
                                });
                              } else {
                                setState(() {
                                  charge =
                                      int.parse(_amountController.text) - total;
                                  _amountKey.currentState!.validate();
                                });
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                                prefixText: 'Rp ', hintText: ' Input Amount'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(flex: 2, child: Text('Charge')),
                      Expanded(flex: 1, child: Text('Rp $charge')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_amountKey.currentState!.validate()) {
                          primaryFocus!.unfocus();
                          // dbHelper.insertTransaction(
                          //   // transactionData, transactionDetailList);
                          //   TransactionData(
                          //       cashierId: cashier,
                          //       total: total.toString(),
                          //       cash: _amountController.text,
                          //       charge: charge.toString(),
                          //       date: DateTime.now().millisecondsSinceEpoch),
                          //   transactionDetailList,
                          // );
                          var dt = DateTime.now();
                          var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
                          String formattedDateTime = formatter.format(dt);
                          print('formattedDateTime $formattedDateTime');
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Are you sure to submit this order?'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        onlineDbHelper.insertTransactions(
                                            TransactionData(
                                                cashierId: cashier,
                                                total: total.toString(),
                                                cash: _amountController.text,
                                                charge: charge.toString(),
                                                timestamp: formattedDateTime),
                                            transactionDetailList);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Success'),
                                                content: Wrap(
                                                  children: const [
                                                    Text(
                                                        'Order has been submitted and now is printing the receipt'),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      setState(() {
                                                        orderList.clear();
                                                        transactionDetailList
                                                            .clear();
                                                        _amountController
                                                            .clear();
                                                        charge = 0;
                                                        total = 0;
                                                        qty = 1;
                                                        productId = 0;
                                                        subTotal = 0;
                                                        total = 0;
                                                        charge = 0;
                                                        transactionId += 1;
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: const Text('Proceed'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderDetailList extends StatefulWidget {
  final List<Map<String, dynamic>> orderList;
  const OrderDetailList({Key? key, required this.orderList}) : super(key: key);

  @override
  State<OrderDetailList> createState() => _OrderDetailListState();
}

class _OrderDetailListState extends State<OrderDetailList> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Item')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Total')),
      ],
      rows: widget.orderList.isEmpty
          ? []
          : widget.orderList
              .map((e) => DataRow(
                    cells: [
                      DataCell(
                        Text(e['productName']),
                      ),
                      DataCell(
                        Text(e['productPrice'].toString()),
                      ),
                      DataCell(
                        Text(e['qty'].toString()),
                      ),
                      DataCell(
                        Text(
                          '${e['qty'] * int.parse(e['productPrice'])}',
                        ),
                      ),
                    ],
                  ))
              .toList(),
    );
  }
}
