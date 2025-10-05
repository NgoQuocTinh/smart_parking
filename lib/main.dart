import 'package:flutter/material.dart';
import 'package:smart_parking/pages/login.dart';
import 'package:smart_parking/pages/home.dart';
import 'package:smart_parking/pages/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => SignInPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

