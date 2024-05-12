import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capstonedesign3/process/classification.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickScreen extends StatelessWidget {
  final File? image;
  final double targetWidth;
  final double targetHeight;

  const ImagePickScreen({Key? key, this.image, this.targetWidth = 300, this.targetHeight = 300}) : super(key: key);

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
                ? Container(
              width: targetWidth,
              height: targetHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // 여백을 위한 테두리 추가
              ),
              child: Image.file(
                image!,
                fit: BoxFit.contain, // 이미지를 자르지 않고 여백이 생기도록 설정
              ),
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassificationScreen(image: File(pickedFile.path)),
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
