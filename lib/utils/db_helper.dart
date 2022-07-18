import 'dart:convert';

import 'package:cassiere/model/product.dart';
import 'package:cassiere/model/report.dart';
import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/model/user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class OnlineDbHelper {
  final _url = 'http://192.168.58.22/cassiere';

  // create future to store.php and insert into store table with parameter name, address
  Future<int> insertStore(String id, String name, String address) async {
    Uri url = Uri.parse('$_url/add_store.php');
    final response = await http.post(url, body: {
      'store': id,
      'name': name,
      'address': address,
    });

    if (response.statusCode == 200) {
      // print('200 ${response.body}');
      if (response.body.contains('Duplicate')) {
        // print('object');
        return 2;
      }
      return 1;
    } else {
      // print('respons ${response.body}');
      return 0;
    }
  }

  // create future read read_store.php and get all store from store table
  Future<List> readStore({String? uid}) async {
    Uri url = Uri.parse('$_url/read_store.php');
    Uri urlExist = Uri.parse('$_url/read_store_exist.php');

    try {
      if (uid == null) {
        final res = await http.get(url);
        if (res.statusCode == 200) {
          List data = json.decode(res.body);
          return data;
        } else {
          // print(response.statusCode);
          throw Exception('Failed to load post');
        }
      } else {
        final response = await http.post(urlExist, body: {
          'uid': uid,
        });

        print('data ${response.body}');
        if (response.body.contains('error')) {
          print('empty');
          return [];
        } else {
          print('ada data');
          var data = json.decode(response.body);
          return [response.body];
        }
      }
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  Future registerUser(
      {required String store,
      required String name,
      required String email,
      required String phone,
      required String password,
      bool? isOwner = true,
      bool? isAdmin = true}) async {
    var url = Uri.parse('$_url/register.php');
    var response = await http.post(url, body: {
      'store_id': store,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'isAdmin': isAdmin! ? '1' : '0',
      'isOwner': isOwner! ? '1' : '0',
    });

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      // print(jsonDecode(req.body));
      return false;
    }
  }

  Future doLogin(String username, String password) async {
    var url = Uri.parse('$_url/login.php');
    var response = await http.post(url, body: {
      'email': username,
      'password': password,
    });

    List data = json.decode(response.body);
    print(data);

    if (data.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setInt('id', int.parse(data[0]['user_id']));
      prefs.setString('name', data[0]['name']);
      prefs.setString('email', data[0]['email']);
      prefs.setString('phone', data[0]['phone']);
      prefs.setString('store', data[0]['store_id']);
      prefs.setBool('isAdmin', data[0]['is_admin'] == '1' ? true : false);
      prefs.setBool('isOwner', data[0]['is_owner'] == '1' ? true : false);
      return 1;
    } else {
      return null;
    }
  }

  Future<List<User>> readUser() async {
    final prefs = await SharedPreferences.getInstance();
    // get store_id
    final store = prefs.getString('store');
    print(store);
    var url = Uri.parse('$_url/read_user.php?store=$store');
    var response = await http.get(url);
    List data = json.decode(response.body);
    print(data);
    List<User> users = data.map((e) => User.fromMap(e)).toList();
    return users;
  }

  Future insertProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getString('store');
    var url = Uri.parse('$_url/add_product.php');
    var response = await http.post(url, body: {
      'store': store,
      'name': product.name,
      'price': product.price,
      'category': product.category,
      'description': product.description,
      // 'description': product.description,
      // 'image': product.image,
    });

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future<List<Product>> readProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getString('store');
    print(store);
    var url = Uri.parse('$_url/read_product.php?store=$store');
    var response = await http.get(url);
    List data = json.decode(response.body);
    print('data $data');
    List<Product> products = data.map((e) => Product.fromMap(e)).toList();
    return products;
  }

  // create future delete product
  Future deleteProduct(String id) async {
    var url = Uri.parse('$_url/delete_product.php');
    var response = await http.post(url, body: {
      'product_id': id,
    });

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future<int> readLastTransaction() async {
    var url = Uri.parse('$_url/read_last_transaction.php');
    var response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        // print(response.body);
        // decode response and return the respons
        var data = json.decode(response.body);
        return int.parse(data);
      } else {
        print(response.statusCode);
        return 0;
      }
    } on Exception catch (e) {
      // TODO
      print(e);
      return 0;
    }
  }

  Future<int> insertTransactions(TransactionData transactionData,
      List<Map<String, dynamic>> transactionDetail) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getInt('id');
    final store = prefs.getString('store');
    var url = Uri.parse('$_url/insert_transactions.php');
    var resp = await http.post(url, body: {
      'store_id': store,
      'user_id': user.toString(),
      'total': transactionData.total,
      'cash': transactionData.cash,
      'charge': transactionData.charge,
      'timestamp': transactionData.timestamp.toString(),
      'detail': json.encode(transactionDetail),
    });
    print(transactionData);
    print(transactionData.cash);
    print(jsonEncode(transactionDetail));
    if (resp.statusCode == 200) {
      print(resp.body);
      return 1;
    } else {
      print('error code ${resp.body}');
      return 0;
    }
  }

  Future<List<TransactionData>> getTransactionDataReport() async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getString('store');
    var url = Uri.parse('$_url/get_transaction_report.php?store_id=$store');
    var response = await http.get(url);

    List data = json.decode(response.body);
    List<TransactionData> transactions =
        data.map((e) => TransactionData.fromMap(e)).toList();
    return transactions;
  }

  Future<List<TransactionDetail>> getTransactionDetailReport() async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getString('store');
    var url = Uri.parse('$_url/get_transaction_report.php?store_id=$store');
    var response = await http.get(url);

    List data = json.decode(response.body);
    List detail = [];

    for (var element in data) {
      print('element ${element['detail']}');
      detail.add(element['detail']);
    }
    print('detail ${detail.expand((element) => element).toList()}');
    List<TransactionDetail> transactionDetails = detail
        .expand((element) => element)
        .toList()
        .map((e) => TransactionDetail.fromMap(e))
        .toList();

    return transactionDetails;
  }

  Future<TransactionReport?> getTransactionReport() async {
    // get store_id from sharedpreferences
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getString('store');
    var url = Uri.parse('$_url/get_transaction_report.php?store_id=$store');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<TransactionData> transactions =
          data.map((e) => TransactionData.fromMap(e)).toList();
      List detail = data[0]['detail'];
      List<TransactionDetail> transactionDetail = detail.map((e) {
        return TransactionDetail.fromMap(e);
      }).toList();

      return TransactionReport(
          transactionData: transactions, transactionDetail: transactionDetail);
    } else {
      return null;
    }
  }
}

class LocalDbHelper {
  final String _tableAdminName = 'user';

  Future initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'cassiere.db');
    return openDatabase(path, version: 1, onCreate: (Database db, int version) {
      db.execute('''
        CREATE TABLE user (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT,
          email TEXT,
          phone TEXT,
          password TEXT,
          isAdmin INTEGER
        )
      ''');
      db.execute('''
        CREATE TABLE product (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT,
          price TEXT,
          category TEXT,
          note TEXT
        )
      ''');
      db.execute('''
        CREATE TABLE transaction_table (
          transactionId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          cashierId TEXT,
          total TEXT,
          cash TEXT,
          charge TEXT,
          date TEXT
        )
      ''');
      db.execute('''
        CREATE TABLE transaction_detail (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          transactionId TEXT,
          productId TEXT,
          productName TEXT,
          productPrice TEXT,
          quantity TEXT,
          subTotal TEXT
        )
      ''');
      // db.execute('''
      //   CREATE TABLE employees (
      //     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      //     name TEXT,
      //     email TEXT,
      //     phone TEXT,
      //     password TEXT
      //   )
      // ''');
    });
  }

  /// ADMIN SECTION
  Future addUser(String name, String email, String phone, String password,
      int isAdmin) async {
    final Database db = await initDb();
    db.insert(
      _tableAdminName,
      {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'isAdmin': isAdmin
      },
    );
  }

  Future addEmployee(
      String name, String email, String phone, String password) async {
    final Database db = await initDb();
    db.insert(
      'user',
      {'name': name, 'email': email, 'phone': phone, 'password': password},
    );
  }

  Future checkUser(String email) async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query(_tableAdminName, where: 'email = ?', whereArgs: [email]);
    if (maps.isEmpty) {
      return 0;
    } else {
      return 1;
    }
  }

  Future deleteEmployee(int id) async {
    final Database db = await initDb();
    db.delete('user', where: 'id = $id');
  }

  Future editProduct() async {
    final Database db = await initDb();
  }

  Future readUser() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query(_tableAdminName);
    return maps;
  }

  /// EMPLOYEE SECTION

  Future<List<User>> readEmployee() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('user', orderBy: 'name');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<List> doLogin(String email, String password,
      {required BuildContext context}) async {
    bool type = false;
    final Database db = await initDb();

    var resp = await db.rawQuery(
        'SELECT * FROM user WHERE email = \'$email\' AND password = \'$password\'');

    if (resp.isNotEmpty) {
      type = resp[0]['isAdmin'] == 1 ? true : false;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', resp[0]['name'].toString());
      prefs.setInt('id', int.parse(resp[0]['id'].toString()));
      prefs.setBool('isAdmin', type);
      prefs.setBool('isLoggedIn', true);

      return [type, 'success'];
    } else {
      return [type, 'failed'];
    }
  }

  /// STOCK SECTION
  Future insertProduct(
      {required String name,
      required String price,
      required String category,
      required String note}) async {
    final Database db = await initDb();
    db.insert(
      'product',
      {'name': name, 'price': price, 'category': category, 'note': note},
    );
  }

  Future updateProduct(
      {required String name,
      required String price,
      required String category,
      required String note}) async {
    final Database db = await initDb();
    db.update(
      'product',
      {'name': name, 'price': price, 'category': category, 'note': note},
    );
  }

  Future<List<Product>> readProducts() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('product');
    List<Product> products = maps.map((e) => Product.fromMap(e)).toList();
    return products;
  }

  Future insertTransaction(TransactionData transactionData,
      List<TransactionDetail> transactionDetail) async {
    final Database db = await initDb();
    Batch batch = db.batch();
    db.insert(
      'transaction_table',
      transactionData.toMap(),
    );
    // db.insert('transaction_detail', transactionDetail.toMap());
    // for (int i = 0; i < transactionDetail.length; i++) {
    //   db.insert(
    //     'transaction_detail',
    //     transactionDetail[i].toMap(),
    //   );
    // }
    // db.insert('transaction_detail', transactionDetail[0].toMap());
    for (var element in transactionDetail) {
      db.insert('transaction_detail', element.toMap());
    }
    // await batch.commit().then((value) => print(value));
  }

  Future<List<TransactionData>> readMainTransaction() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> mainTable =
        await db.query('transaction_table');

    List<TransactionData> newlist =
        mainTable.map((e) => TransactionData.fromMap(e)).toList();

    return newlist;
  }

  Future<List<TransactionDetail>> readDetailTransaction() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('transaction_detail');
    final List<TransactionDetail> result =
        maps.map((e) => TransactionDetail.fromMap(e)).toList();
    return result;
  }

  Future clearTransactions() async {
    final Database db = await initDb();
    await db.delete('transaction_table');
    await db.delete('transaction_detail');
  }
}
