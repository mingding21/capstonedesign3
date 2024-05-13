import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstonedesign3/process/classification.dart';

class ImagePickScreen extends StatefulWidget {
  final double targetWidth;
  final double targetHeight;

  const ImagePickScreen({Key? key, this.targetWidth = 300, this.targetHeight = 300}) : super(key: key);

  @override
  _ImagePickScreenState createState() => _ImagePickScreenState();
}

class _ImagePickScreenState extends State<ImagePickScreen> {
  File? _image;

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
            _image != null ? _buildImage() : _buildImagePicker(context),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  _startClassification(context, _image!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('이미지를 먼저 선택해주세요.'),
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

  Widget _buildImagePicker(BuildContext context) {
    return Container(
      width: widget.targetWidth,
      height: widget.targetHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // 여백을 위한 테두리 추가
      ),
      child: ElevatedButton(
        onPressed: () async {
          final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              _image = File(pickedFile.path);
            });
          }
        },
        child: Text('이미지 선택'),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: widget.targetWidth,
      height: widget.targetHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // 여백을 위한 테두리 추가
      ),
      child: Image.file(
        _image!,
        fit: BoxFit.contain, // 이미지를 자르지 않고 여백이 생기도록 설정
      ),
    );
  }

  void _startClassification(BuildContext context, File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassificationScreen(image: image),
      ),
    );
  }
}
