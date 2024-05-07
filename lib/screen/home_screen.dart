import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'imagepick_screen.dart';
import 'camera_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePickScreen(image: File(pickedImage.path)),
        ),
      );
    } else {
      print('선택된 이미지 없음');
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final picker = ImagePicker();
    final takenPhoto = await picker.pickImage(source: ImageSource.camera);

    if (takenPhoto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(photo: File(takenPhoto.path)),
        ),
      );
    } else {
      print('촬영된 이미지 없음');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('물고기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'asset/image/fish_image2.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              '당신이 잡은 물고기, 정체가 뭘까요?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: _getImageFromGallery,
                    ),
                    Text(
                      '갤러리',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 20), // 버튼 사이의 간격 조정
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _takePhotoWithCamera,
                    ),
                    Text(
                      '촬영하기',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
