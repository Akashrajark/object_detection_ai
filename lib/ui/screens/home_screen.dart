import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:object_detection_ai/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _darkMode = true;
  XFile? _image;
  String _response = "";
  final ImagePicker _picker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> speakText(String text) async {
    await _flutterTts.speak(text);
  }

  void _initializeTts() {
    _flutterTts.setLanguage("en-US"); // Set language to English
    _flutterTts.setPitch(1.0); // Set pitch for voice
    _flutterTts.setSpeechRate(0.5); // Set speech rate for readability
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _image = image;
          _response = ""; // Clear previous response
          _isLoading = true;
        });

        // Process the image with Gemini
        final file = File(image.path);
        final gemini = Gemini.instance;

        gemini.textAndImage(
          text:
              "What is this picture? , Explain it like you are explaining to a blind man.", // prompt
          images: [file.readAsBytesSync()], // Convert image to byte data
        ).then((value) {
          setState(() {
            _isLoading = false;
            _response = value?.content?.parts?.last.text ?? 'No response';
          });
          log(_response);
          speakText(_response); // Trigger TTS for the response
        }).catchError((e) {
          log('Error processing image', error: e);
          setState(() {
            _isLoading = false;
            _response = 'Error processing image';
          });
        });
      }
    } catch (error) {
      log('Error selecting image', error: error);
      setState(() {
        _isLoading = false;
        _response = 'Error selecting image';
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 55,
              width: 55,
            ),
            Text(
              "vision",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              _darkMode = !_darkMode;
            },
            icon: Icon(
              _darkMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _image != null
                  ? Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_image!.path),
                        ),
                      ),
                    )
                  : Text(
                      'No image selected',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
          SizedBox(height: 20),
          _response.isNotEmpty
              ? RichText(
                  text: TextSpan(
                    text: 'Response: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                    children: [
                      TextSpan(
                        text: _response,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                onTap: () => _pickImage(ImageSource.camera),
                label: 'Camera',
                iconData: Icons.camera_alt,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: CustomButton(
                onTap: () => _pickImage(ImageSource.gallery),
                label: 'Gallery',
                iconData: Icons.browse_gallery,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final IconData iconData;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
