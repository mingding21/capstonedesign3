import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstonedesign3/process/classification.dart';

class CameraScreen extends StatefulWidget {
  final double targetWidth;
  final double targetHeight;

  const CameraScreen({Key? key, this.targetWidth = 300, this.targetHeight = 300}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _takenPhoto;

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
            _takenPhoto != null ? _buildImage() : _buildImagePicker(context),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_takenPhoto != null) {
                  _startClassification(context, _takenPhoto!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('먼저 사진을 찍어주세요.'),
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
        onPressed: _takePhoto,
        child: Text('촬영하기'),
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
        _takenPhoto!,
        fit: BoxFit.contain, // 이미지를 자르지 않고 여백이 생기도록 설정
      ),
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final takenPhoto = await picker.pickImage(source: ImageSource.camera);

    if (takenPhoto != null) {
      setState(() {
        _takenPhoto = File(takenPhoto.path);
      });
    } else {
      print('촬영된 이미지 없음');
    }
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
