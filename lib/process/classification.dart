import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:capstonedesign3/screen/fishinfo_screen.dart';

class ClassificationScreen extends StatefulWidget {
  final File? image;
  final double targetWidth;
  final double targetHeight;

  const ClassificationScreen({Key? key, required this.image, this.targetWidth = 224, this.targetHeight = 224}) : super(key: key);

  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  List<dynamic>? _outputs;
  bool _loading = false;
  late Interpreter _interpreter;

  Map<int, String> classLabels = {
    0: 'Bangus (갯농어)',
    1: 'Freshwater Eel (뱀장어)',
    2: 'Grass Carp (초어)',
    3: 'Glass Perchlet (유리잉어)',
    4: 'Catfish (메기)',
    5: 'Silver Perch (실버퍼치)',
    6: 'Gold Fish (금붕어)',
    7: 'Tenpounder (당멸치)',
    8: 'Shrimp (새우)',
    9: 'Goby (망둥이)',
    10: 'Mudfish (미꾸라지)',
    11: 'Fourfinger Threadfin (네날가지)',
    12: 'Janitor Fish',
    13: 'Knifefish (칼고기)',
    14: 'Black Spotted Barb (검은 점 바브)',
    15: 'Big Head Carp (대두어)',
    16: 'Hourse Mackerel (전갱이)',
    17: 'Long-Snouted Pipefish (긴 주둥이 파이브피쉬)',
    18: 'Gilt-Head Bream (귀족 도미)',
    19: 'Green Spotted Puffer (녹색 점박이 복어)',
    20: 'Silver Barb (실버바브)',
    21: 'Silver Carp (백련어)',
    22: 'Sea Bass (배스)',
    23: 'Pangasius (판가시우스)',
    24: 'Red Sea Bream (참돔)',
    25: 'Mullet (숭어)',
    26: 'Indian Carp (인도 잉어)',
    27: 'Gourami (버들붕어)',
    28: 'Perch (농어)',
    29: 'Scat Fish (식분어)',
    30: 'Striped Red Mullet (줄무늬 붉은 숭어)',
    31: 'Trout (송어)',
    32: 'Red Mullet (붉은 숭어)',
    33: 'Indo-Pacific Tarpon (풀잉어)',
    34: 'Snakehead (가물치)',
    35: 'Climbing Perch (등목어)',
    36: 'Jaguar Gapote',
    37: 'Mosquito Fish (모기고기)',
    38: 'Black Sea Sprat (검정청어)',
    39: 'Tilapia (틸라피아)'
  };

  @override
  void initState() {
    super.initState();
    _loadModelAndClassifyImage();
  }

  Future<void> _loadModelAndClassifyImage() async {
    print('모델 로딩 중');
    setState(() {
      _loading = true;
    });

    try {
      // 모델 로딩
      _interpreter = await Interpreter.fromAsset('asset/model/fish_classification_model_final.tflite');

      print('모델 로딩 완료');
      _classifyImage(widget.image!); // 이미지가 여기서 전달되었으므로 따로 선택할 필요 없음
    } catch (e) {
      print('모델 로딩 실패: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _classifyImage(File image) async {
    print('분류 작업 시작');
    setState(() {
      _loading = true;
    });

    try {
      // 이미지 전처리 및 추론 실행
      var output = await _runInference(image);

      print('분류 작업 완료');
      setState(() {
        _outputs = output;
        _loading = false;
      });
    } catch (e) {
      print('이미지 분류 실패: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<List<dynamic>> _runInference(File image) async {
    // 이미지 전처리
    var inputImage = await _preprocessImage(image);

    // 추론 실행
    var output = List.filled(1, List.filled(40, 0.0));
    _interpreter.run(inputImage, output);

    // 예측된 클래스 가져오기
    var predictedClassIndex = output[0].indexOf(output[0].reduce((curr, next) => curr > next ? curr : next));

    // 클래스 이름 가져오기
    var predictedClassName = classLabels[predictedClassIndex];

    // 정확도 계산
    var confidence = output[0][predictedClassIndex];

    return [predictedClassName, confidence];
  }

  Future<Uint8List> _preprocessImage(File image) async {
    // 이미지를 224x224 크기로 변환
    var rawImage = await image.readAsBytes();
    var decodedImage = img.decodeImage(rawImage);

    var resizedImage = img.copyResize(decodedImage!, width: 224, height: 224);

    // 이미지를 TensorFlow 모델의 입력 형식에 맞게 정규화
    var normalizedBytes = resizedImage.getBytes();
    var floatList = Float32List(224 * 224 * 3);
    for (var i = 0; i < 224 * 224 * 3; i++) {
      floatList[i] = (normalizedBytes[i] - 127.5) / 127.5;
    }

    return floatList.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('물고기 분류 결과'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.targetWidth,
              height: widget.targetHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // 여백을 위한 테두리 추가
              ),
              child: Image.file(
                widget.image!,
                fit: BoxFit.contain, // 이미지를 자르지 않고 여백이 생기도록 설정
              ),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _outputs != null
                ? Column(
              children: [
                if (_outputs![1] < 0.5)
                  Text(
                    "오류. 다른 사진을 골라주세요.",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  )
                else
                  Column(
                    children: [
                      Text(
                        "분류 결과: ${_outputs![0]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "정확도: ${( _outputs![1] * 100).toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FishInfoScreen(fishName: _outputs![0].split(' (')[0])),
                          );
                        },
                        child: Text('물고기 정보'),
                      ),
                    ],
                  )
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.close(); // 메모리 누수 방지, 모델 닫기
    super.dispose();
  }
}
