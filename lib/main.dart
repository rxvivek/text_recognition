import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:text_recognition/text_ocr.dart';

import 'camera_screen.dart';
import 'edge_detection_screen.dart';
import 'genius_scan.dart';

// Global variable for storing the list of cameras available
List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      //TextOcr(title: 'OCR',),
    //   MyScaffoldBody(),
      const CameraScreen(),
      //  const EdgeDetectionScreen(),
    );
  }
}


