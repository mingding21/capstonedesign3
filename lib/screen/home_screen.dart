import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('안녕하세요'),
      ),
      body: Center(
        child: Text(
          '안녕하세요',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
