import 'dart:io';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  final File? photo;
  final double targetWidth;
  final double targetHeight;

  const CameraScreen({Key? key, this.photo, this.targetWidth = 300, this.targetHeight = 300}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('물고기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photo != null
                ? Container(
              width: targetWidth,
              height: targetHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // 여백을 위한 테두리 추가
              ),
              child: Image.file(
                photo!,
                fit: BoxFit.contain, // 이미지를 자르지 않고 여백이 생기도록 설정
              ),
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 정체 알아보기 버튼을 눌렀을 때의 동작 구현
              },
              child: Text('정체 알아보기'),
            ),
          ],
        ),
      ),
    );
  }
}
