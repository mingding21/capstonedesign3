import 'package:flutter/material.dart';

class ImagePickScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('갤러리'),
      ),
      body: Center(
        child: Text('이곳은 갤러리 화면입니다.'),
      ),
    );
  }
}
