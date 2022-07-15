
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;

    const DetailScreen({Key? key,required this.imagePath});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  late final String _imagePath;
  late final TextRecognizer _textDetector;
  Size? _imageSize;
//  List<TextElement> _elements = [];

  List<String>? _listEmailStrings;



  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;

    setState(() {
      _imageSize = imageSize;
    });
  }

  Map map = <int,List<String>>{};

  void addElement(List<Point<int>> cornerPoint, String text){
    print("$cornerPoint ------  $text");
    if(map.containsKey(cornerPoint[0].y)){
      int diff =  cornerPoint[0].y - cornerPoint[0].y;
      if((diff <= 0 && diff >= -11) || (diff >= 0 && diff <= 11)){
        map.update(cornerPoint[0].y, (value) => value.add(text));
      }
    }else{
  map[cornerPoint[0].y] = [text];
    }
   print(map);
  }

  void _recognizeEmails() async {
    _getImageSize(File(_imagePath));
    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
// Retrieving the RecognisedText from the InputImage
    final text = await _textDetector.processImage(inputImage);

    // Regular expression for verifying an email address
    String pattern2 = r"([0-9]{1,3}\.[0-9]{2})";
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(pattern2);

    List<String> emailStrings = [];


    // for(TextBlock block in text.blocks){
    //   for(TextLine line in block.lines){
    //  //  for(TextElement element in line.elements){
    //      print("----------------");
    //      print(line.cornerPoints);
    //      addElement(line.cornerPoints,line.text.toString());
    //      print("----------------");
    //   // }
    //  }
    // }
    print(map);
// Finding and storing the text String(s)
    for (TextBlock block in text.blocks) {
     for(TextLine line in block.lines){

       for(TextElement element in line.elements){
       //  if (regEx.hasMatch(element.text)) {
          emailStrings.add(element.text);
      //   }
         emailStrings.add("-------");
       }
       emailStrings.add(line.text);
       emailStrings.add("--------------------------");
     }
     emailStrings.add(block.text);
     emailStrings.add("******************************");
    }
//
//      emailStrings.add("-----");
//       // for (TextLine line in block.lines) {
//       //   // if (regEx.hasMatch(line.text)) {
//       //   //   emailStrings.add(line.text);
//       //   // }
//       //
//       // }
//     }
    setState(() {
      _listEmailStrings = emailStrings;
   //   print(emailStrings);
    });
  }



  @override
  void initState() {
    _imagePath = widget.imagePath;
    // Initializing the text detector
    _textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    _recognizeEmails();
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    _textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: _imageSize!.aspectRatio,
              child: Image.file(
                File(_imagePath),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Identified Text",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: _listEmailStrings != null
                              ? ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _listEmailStrings!.length,
                            itemBuilder: (context, index) =>
                                Text(_listEmailStrings![index]),
                          )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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