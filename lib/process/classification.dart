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
    1: 'Big Head Carp (대두어)',
    2: 'Black Sea Sprat (검정청어)',
    3: 'Black Spotted Barb (검은 점 바브)',
    4: 'Catfish (메기)',
    5: 'Climbing Perch (등목어)',
    6: 'Fourfinger Threadfin (네날가지)',
    7: 'Freshwater Eel (뱀장어)',
    8: 'Gilt-Head Bream (귀족 도미)',
    9: 'Glass Perchlet (유리잉어)',
    10: 'Goby (망둥이)',
    11: 'Gold Fish (금붕어)',
    12: 'Gourami (버들붕어)',
    13: 'Grass Carp (초어)',
    14: 'Green Spotted Puffer (녹색 점박이 복어)',
    15: 'Hourse Mackerel (전갱이)',
    16: 'Indian Carp (인도 잉어)',
    17: 'Indo-Pacific Tarpon (풀잉어)',
    18: 'Jaguar Gapote',
    19: 'Janitor Fish',
    20: 'Knifefish (칼고기)',
    21: 'Long-Snouted Pipefish (긴 주둥이 파이프피쉬)',
    22: 'Mosquito Fish (모기고기)',
    23: 'Mudfish (미꾸라지)',
    24: 'Mullet (숭어)',
    25: 'Pangasius (판가시우스)',
    26: 'Perch (농어)',
    27: 'Red Mullet (붉은 숭어)',
    28: 'Red Sea Bream (참돔)',
    29: 'Scat Fish (식분어)',
    30: 'Sea Bass (배스)',
    31: 'Shrimp (새우)',
    32: 'Silver Barb (실버바브)',
    33: 'Silver Carp (백련어)',
    34: 'Silver Perch (실버퍼치)',
    35: 'Snakehead (가물치)',
    36: 'Striped Red Mullet (줄무늬 붉은 숭어)',
    37: 'Tenpounder (당멸치)',
    38: 'Tilapia (틸라피아)',
    39: 'Trout (송어)'
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
