// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'package:image/image.dart' as img;

// class Classify extends StatefulWidget {
//   @override
//   _ClassifyState createState() => _ClassifyState();
// }

// class _ClassifyState extends State<Classify> with TickerProviderStateMixin {
//   File? _image;

//   late double _imageWidth;
//   late double _imageHeight;
//   bool _busy = false;
//   double _containerHeight = 0;
//   late tfl.Interpreter _interpreter;

//   late List _recognitions = [];
//   ImagePicker _picker = ImagePicker();

//   late AnimationController _controller;
//   static const List<IconData> icons = const [Icons.camera_alt, Icons.image];

//   Map<String, int> _ingredients = {};
//   String _selected0 = "";
//   String _selected1 = "";
//   String val0 = "";
//   String val1 = "";

//   bool _isLoading = false;

//   void _setLoading(bool value) {
//     setState(() {
//       _isLoading = value;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _busy = true;

//     loadModel().then((val) {
//       setState(() {
//         _busy = false;
//       });
//     });

//     _controller = new AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//   }

  

//   selectFromImagePicker({required bool fromCamera}) async {
//     XFile? pickedFile = fromCamera
//         ? await _picker.pickImage(source: ImageSource.camera)
//         : await _picker.pickImage(source: ImageSource.gallery);
//     late var image = File(pickedFile!.path);
//     if (image == null) return;
//     setState(() {
//       _busy = true;
//     });
//     predictImage(image);
//   }

//   predictImage(File image) async {
//     if (image == null) return;

//     _setLoading(true);

//     await classify(image);

//     print(_interpreter.getInputTensors());
//     print(_interpreter.getOutputTensors());

//     FileImage(image)
//         .resolve(const ImageConfiguration())
//         .addListener((ImageStreamListener((ImageInfo info, bool _) {
//           setState(() {
//             _imageWidth = info.image.width.toDouble();
//             _imageHeight = info.image.height.toDouble();
//           });
//         })));

//     setState(() {
//       _image = image;
//       _busy = false;
//     });

//     _setLoading(false);
//   }

//   classify(File image) async {
//     var resized = img.copyResize(img.decodeImage(await image.readAsBytes())!,
//         height: 600, width: 600);
//     var convertedBytes = Float32List(1 * 600 * 600 * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;
//     for (var pixel in resized.getBytes()) {
//       buffer[pixelIndex] = pixel / 255.0;
//       pixelIndex++;
//     }

//     var outputBuffer = List.filled(1 * 2, 0).reshape([1, 2]);

//     _interpreter.run(buffer.buffer.asUint8List(), outputBuffer);

//     print(outputBuffer);
//     // var recognitions = await Tflite.runModelOnImage(
//     // //     path: image.path, // required
//     // //     imageMean: 0.0, // defaults to 117.0
//     // //     imageStd: 255.0, // defaults to 1.0
//     // //     numResults: 2, // defaults to 5
//     // //     threshold: 0.2, // defaults to 0.1
//     // //     asynch: true // defaults to true
//     // //     );

//     setState(() {
//       //   _recognitions = recognitions ?? [];
//       //   print(_recognitions);

//       _recognitions = [1, 2];

//       val0 =
//           '${(double.parse(outputBuffer[0][0].toString()) * 100).toStringAsFixed(0)}%';
//       val1 =
//           '${(double.parse(outputBuffer[0][1].toString()) * 100).toStringAsFixed(0)}%';
//     });
//   }

//   _imagePreview(File image) {
//     _controller.reverse();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Expanded(
//           flex: 7,
//           child: ListView(
//             children: <Widget>[
//               Image.file(image),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text('Image Class',
//                     style:
//                         TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
//               ),
//               Text("Blur : $val0"),
//               Text("Sharp : $val1"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: _isLoading,
//       progressIndicator:
//           SpinKitWanderingCubes(color: Theme.of(context).primaryColor),
//       child: CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(
//             middle: const Text('Blur Detect'),
//             leading: Row(children: [
//               IconButton(
//                 icon: Icon(Icons.image,
//                     color: Theme.of(context).secondaryHeaderColor),
//                 onPressed: () {
//                   selectFromImagePicker(fromCamera: false);
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.camera_alt,
//                     color: Theme.of(context).secondaryHeaderColor),
//                 onPressed: () {
//                   selectFromImagePicker(fromCamera: true);
//                 },
//               ),
//             ]),
//             backgroundColor: Colors.blue,
//           ),
//           child: _content(_image)),
//     );
//   }

//   _content(File? image) {
//     if (image == null) {
//       return const Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.image, size: 100.0, color: Colors.grey),
//             ),
//             Center(
//                 child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('No Image',
//                   style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey)),
//             )),
//             Center(
//               child: Text('Please take or select a photo for blur detection.',
//                   style: TextStyle(color: Colors.grey)),
//             )
//           ]);
//     } else {
//       return _imagePreview(image);
// //      return Container();
//     }
//   }
// }
