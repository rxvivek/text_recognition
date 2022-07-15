import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:text_recognition/text_ocr.dart';

class MyScaffoldBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () {
            copyLanguageFile().then((folder) {
             /* FlutterGeniusScan.scanWithConfiguration({
                'source': 'camera',
                'multiPage': false,
                'ocrConfiguration': {
                  'languages': ['eng'],
                  'languagesDirectoryUrl': folder.path
                }
              }).then((result) async {
                String documentUrl = result['multiPageDocumentUrl'];
                print(documentUrl);

                // OpenFile.open(documentUrl.replaceAll("file://", '')).then(
                //         (result) => debugPrint(result.message),
                //     onError: (error) => displayError(context, error));
              }, onError: (error) => displayError(context, error));*/
            });
          },
          child: Text("START SCANNING"),
        ));
  }
  Future<List<int>> _readDocumentData(String name) async {
   return File(name).readAsBytesSync();
  //  final ByteData data = await rootBundle.load(name);
   // return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
  Future<Directory> copyLanguageFile() async {
    Directory languageFolder = await getApplicationSupportDirectory();
    File languageFile = File(languageFolder.path + "/eng.traineddata");
    if (!languageFile.existsSync()) {
      ByteData data = await rootBundle.load("assets/eng.traineddata");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await languageFile.writeAsBytes(bytes);
    }
    return languageFolder;
  }

  void displayError(BuildContext context, PlatformException error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
  }
  void _showResult(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Extracted text'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}