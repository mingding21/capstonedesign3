import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassificationScreen extends StatefulWidget {
  final File? image;

  const ClassificationScreen({Key? key, required this.image}) : super(key: key);

  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  List? _outputs;
  bool _loading = false;

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
            Image.file(
              widget.image!,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _outputs != null
                ? Text(
              "분류 결과: ${_outputs![0].indexOf(_outputs![0].reduce((curr, next) => curr > next ? curr : next))}",
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
    _classifyImage(widget.image!);
  }

  Future<void> _classifyImage(File image) async {
    setState(() {
      _loading = true;
    });

    // Load the TFLite model
    var interpreter = await Interpreter.fromAsset('fish_cnn_model.tflite');

    // Preprocess the image
    var inputImage = image.readAsBytesSync();
    var input = inputImage.buffer.asUint8List();

    // Run inference
    var output = List.generate(1, (_) => List.filled(9, 0.0));
    interpreter.run(input, output);

    setState(() {
      _loading = false;
      _outputs = output;
    });
  }
}

