import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../../core/database/db_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123');

  void _login() async {
    final db = await DBHelper.database;
    final result = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [_usernameController.text, _passwordController.text]);

    if (result.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اسم المستخدم أو كلمة المرور غير صحيحة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'اسم المستخدم')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'كلمة المرور'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('تسجيل الدخول')),
          ],
        ),
      ),
    );
  }
}
