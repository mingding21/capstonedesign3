import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickScreen extends StatelessWidget {
  final File? image;

  const ImagePickScreen({Key? key, this.image}) : super(key: key);

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
            image != null
                ? Image.file(
              image!,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
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
