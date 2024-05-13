import 'package:flutter/material.dart';
import 'package:capstonedesign3/screen/imagepick_screen.dart';
import 'package:capstonedesign3/screen/camera_screen.dart';

class HomeScreen extends StatelessWidget {
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ImagePickScreen()),
                        );
                      },
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraScreen()),
                        );
                      },
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
