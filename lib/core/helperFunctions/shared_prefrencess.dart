import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // حفظ بيانات المستخدم
  Future<void> saveUserData(String email, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('username', username);
  }

  // استرجاع البريد الإلكتروني
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // استرجاع اسم المستخدم
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // مسح بيانات المستخدم عند الخروج
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('username');
  }
}
