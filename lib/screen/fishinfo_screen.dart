import 'package:flutter/material.dart';

class FishInfoScreen extends StatelessWidget {
  final String fishName;

  const FishInfoScreen({Key? key, required this.fishName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('물고기 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '물고기 종류: $fishName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // 여기에 물고기에 대한 정보를 추가하세요.
          ],
        ),
      ),
    );
  }
}
