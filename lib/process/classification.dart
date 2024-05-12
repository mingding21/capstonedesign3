import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassificationScreen extends StatefulWidget {
  final File? image;
  final double targetWidth;
  final double targetHeight;

  const ClassificationScreen({Key? key, required this.image, this.targetWidth = 224, this.targetHeight = 224}) : super(key: key);

  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  List<String>? _outputs;
  bool _loading = false;
  late Interpreter _interpreter;

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
                width: widget.targetWidth,
                height: widget.targetHeight,
                fit: BoxFit.cover, // 이미지를 자르지 않고 여백이 생기도록 설정
              ),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _outputs != null
                ? Text(
              "분류 결과: ${_outputs![0]}",
              style: TextStyle(fontSize: 20),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

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
      _interpreter = await Interpreter.fromAsset('asset/model/fish_cnn_model_real.tflite');

      print('모델 로딩 완료');
      _classifyImage(widget.image!);
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

  Future<List<String>> _runInference(File image) async {
    // 이미지 전처리
    var inputImage = await _preprocessImage(image);

    // 추론 실행
    var output = List.filled(1, List.filled(9, 0.0));
    _interpreter.run(inputImage, output);

    // 예측된 클래스 가져오기
    var predictedClassIndex = output[0].indexOf(output[0].reduce((curr, next) => curr > next ? curr : next));
    var classLabels = ['Black Sea Sprat', 'Gilt-Head Bream', 'Hourse Mackerel', 'Red Mullet', 'Red Sea Bream', 'Sea Bass', 'Shrimp', 'Striped Red Mullet', 'Trout'];
    var predictedClassName = classLabels[predictedClassIndex];

    return [predictedClassName];
  }

  Future<Uint8List> _preprocessImage(File image) async {
    // 이미지를 224x224 크기로 변환
    var bytes = await image.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  @override
  void dispose() {
    _interpreter.close(); // 메모리 누수 방지를 위해 모델을 닫습니다.
    super.dispose();
  }
}
