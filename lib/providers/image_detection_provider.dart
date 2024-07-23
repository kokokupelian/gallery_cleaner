import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ImageDetectionProvider with ChangeNotifier {
  // #region interpreter
  late Interpreter _interpreter;
  Interpreter get interpreter {
    return _interpreter;
  }

  set interpreter(Interpreter value) {
    _interpreter = value;
  }
  // #endregion

  loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset("assets/tflite/model.tflite");
      // final _interpreter =
      //     await tfl.IsolateInterpreter.create(address: interpreter.address);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  Future<Map<String, double>> classify(File image) async {
    var resized = img.copyResize(img.decodeImage(await image.readAsBytes())!,
        height: 600, width: 600);
    var convertedBytes = Float32List(1 * 600 * 600 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var pixel in resized.getBytes()) {
      buffer[pixelIndex] = pixel / 255.0;
      pixelIndex++;
    }

    var outputBuffer = List.filled(1 * 2, 0).reshape([1, 2]);

    _interpreter.run(buffer.buffer.asUint8List(), outputBuffer);

    Map<String, double> output = {};

    output["blur"] = (double.parse(outputBuffer[0][0].toString()) * 100);
    output['clear'] = (double.parse(outputBuffer[0][1].toString()) * 100);

    return output;
  }
}
