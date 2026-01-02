import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const MohamedHussienApp());
}

class MohamedHussienApp extends StatelessWidget {
  const MohamedHussienApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohamed Hussien',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textDirection: TextDirection.rtl,
        fontFamily: 'Cairo',
      ),
      home: LoginScreen(),
    );
  }
}
