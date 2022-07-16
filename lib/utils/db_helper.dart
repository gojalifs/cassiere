import 'dart:convert';

import 'package:cassiere/model/product.dart';
import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/model/user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class OnlineDbHelper {
  final _url = 'https://192.168.58.22/cassiere';

  Future registerUser(String name, String email, String phone, String password,
      int isAdmin) async {
    var url = Uri.parse('$_url/register.php');
  }

  Future doLogin(String username, String password) async {
    var url = Uri.parse('$_url/login.php');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      return data['data'];
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
