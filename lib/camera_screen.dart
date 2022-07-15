import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition/text_ocr.dart';

import 'detail_screen.dart';
import 'main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
   late final CameraController _controller;

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  //prevent any memory leaks
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Initializes camera controller to preview on screen
  Future<void> _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[0], //0 for back camera and 1 for front camera
      ResolutionPreset.max,
      enableAudio: false,
    );
    _controller = cameraController;

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Takes picture with the selected device camera, and
// returns the image path
  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      _initializeCamera();
      print("Controller is not initialized");
      return null;
    }
    String? imagePath;

    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      // Turning off the camera flash
      _controller.setFlashMode(FlashMode.auto);
      // Returns the image in cross-platform file abstraction
      final XFile file = await _controller.takePicture();
      // Retrieving the path
      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MLKit'),
      ),
      body:  _controller.value.isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text("Click"),
                      onPressed: () async {
                        // If the returned path is not null, navigate
                        // to the DetailScreen
                        await _takePicture().then((String? path) {
                          if (path != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  imagePath: path,
                                ),
                              ),
                              // MaterialPageRoute(
                              //   builder: (context) => TextOcr(
                              //     path: path,
                              //   ),
                              // ),
                            );
                          } else {
                            print('Image path not found!');
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
