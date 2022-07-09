import 'package:cassiere/model/product.dart';
import 'package:cassiere/model/transaction.dart';
import 'package:cassiere/model/user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
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

  Future<bool> doLogin(String email, String password,
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

      return type;
    } else {
      return type;
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
