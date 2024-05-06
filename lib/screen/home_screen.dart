import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'imagepick_screen.dart';


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
              width: 150, // 이미지의 가로 크기 조절
              height: 150, // 이미지의 세로 크기 조절
            ),
            SizedBox(height: 20), // 이미지와 텍스트 사이의 간격 조정
            Text(
              '당신이 잡은 물고기, 정체가 뭘까요?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // 텍스트와 버튼 사이의 간격 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.crop_original), // 갤러리 버튼에 카메라 아이콘 추가
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePickScreen(),
                          ),
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
                      icon: Icon(Icons.add_a_photo), // 촬영 버튼에 카메라 아이콘 추가
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(),
                          ),
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
