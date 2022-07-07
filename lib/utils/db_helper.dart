import 'package:cassiere/model/product.dart';
import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/model/user.dart';
import 'package:cassiere/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final String _tableAdminName = 'user';
  final String _columnId = 'id';
  final String _columnName = 'name';
  final String _columnEmail = 'email';
  final String _columnPhone = 'phone';
  final String _columnPassword = 'password';
  final String _columnStatus = 'status';

  Future initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'cassiere.db');
    return openDatabase(path, version: 1, onCreate: (Database db, int version) {
      db.execute('''
        CREATE TABLE user (
          $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          $_columnName TEXT,
          $_columnEmail TEXT,
          $_columnPhone TEXT,
          $_columnPassword TEXT,
          $_columnStatus TEXT          
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
          transactionDetail TEXT,
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
          productName TEXT,
          quantity TEXT,
          productPrice TEXT,
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
      String status) async {
    final Database db = await initDb();
    db.insert(
      _tableAdminName,
      {
        _columnName: name,
        _columnEmail: email,
        _columnPhone: phone,
        _columnPassword: password,
        _columnStatus: status
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

  Future editProduct() async {
    final Database db = await initDb();
  }

  Future readUser() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query(_tableAdminName);
    print(maps);
    return maps;
  }

  /// EMPLOYEE SECTION

  Future readEmployee() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('user');
    return maps;
  }

  Future<String> doLogin(String email, String password,
      {required BuildContext context}) async {
    String type = '';
    final Database db = await initDb();
    var navigator = Navigator.of(context);
    var resp = await db.rawQuery(
        'SELECT * FROM user WHERE email = \'$email\' AND password = \'$password\'');
    if (resp.isNotEmpty) {
      type = resp[0]['status'].toString();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', resp[0]['name'].toString());
      final username = resp.map((e) => User.fromMap(e)).toList();
      print(username);
      return type;
    } else {
      return '0';
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
      TransactionDetail transactionDetail) async {
    final Database db = await initDb();

    await db.insert(
      'transaction_table',
      transactionData.toMap(),
    );
    await db.insert('transaction_detail', transactionDetail.toMap());
  }

  Future<List<Map<String, dynamic>>> readTransaction() async {
    final Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('transaction_table');
    return maps;
  }
}
