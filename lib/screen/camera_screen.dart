import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('촬영 화면'),
      ),
      body: Center(
        child: Text('이곳은 카메라 촬영 화면입니다.'),
      ),
    );
  }
}
