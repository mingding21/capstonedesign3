import 'package:flutter/material.dart';
import 'package:capstonedesign3/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // HomeScreen 위젯을 호출합니다.
    );
  }
}


