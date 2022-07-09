import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name')!;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdmin')!;
  }
}
