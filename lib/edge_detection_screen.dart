import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'detail_screen.dart';

class EdgeDetectionScreen extends StatefulWidget {
  const EdgeDetectionScreen({Key? key}) : super(key: key);

  @override
  State<EdgeDetectionScreen> createState() => _EdgeDetectionScreenState();
}

class _EdgeDetectionScreenState extends State<EdgeDetectionScreen> {
  String? _imagePath;
  Future<void> getImage() async {
    String? imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      imagePath = (await EdgeDetection.detectEdge);
      print("$imagePath");
      if(imagePath != null){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              imagePath: imagePath!,
            ),
          ),
        );
      }

    } on PlatformException catch (e) {
      imagePath = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: getImage,
              child: Text('Scan'),
            ),
          ),
          SizedBox(height: 20),
          Text('Cropped image path:'),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Text(
              _imagePath.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Visibility(
            visible: _imagePath != null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(_imagePath ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
