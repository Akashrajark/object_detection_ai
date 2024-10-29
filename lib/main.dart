import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  Gemini.init(apiKey: 'AIzaSyD0Bd0ARldle8V3RraayyZkm3LP5yCOcY4');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageProcessingScreen(),
    );
  }
}

class ImageProcessingScreen extends StatefulWidget {
  const ImageProcessingScreen({super.key});

  @override
  _ImageProcessingScreenState createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
  XFile? _image;
  String _response = "";
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _image = image;
          _response = ""; // Clear previous response
        });

        // Process the image with Gemini
        final file = File(image.path);
        final gemini = Gemini.instance;

        gemini.textAndImage(
          text: "What is this picture?", // Customize your prompt
          images: [file.readAsBytesSync()], // Convert image to byte data
        ).then((value) {
          setState(() {
            _response = value?.content?.parts?.last.text ?? 'No response';
          });
          log(_response);
        }).catchError((e) {
          log('Error processing image', error: e);
          setState(() {
            _response = 'Error processing image';
          });
        });
      }
    } catch (error) {
      log('Error selecting image', error: error);
      setState(() {
        _response = 'Error selecting image';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gemini Image Processing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(File(_image!.path))
                : Text('No image selected'),
            SizedBox(height: 20),
            _response.isNotEmpty ? Text('Response: $_response') : Container(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Use Camera'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Pick from Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
