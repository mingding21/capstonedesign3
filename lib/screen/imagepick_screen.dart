import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capstonedesign3/process/classification.dart';

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
                if (image != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassificationScreen(image: image!), // ClassificationScreen 클래스에 image 매개변수 전달
                    ),
                  );
                }
              },
              child: Text('정체 알아보기'),
            ),
          ],
        ),
      ),
    );
  }
}
