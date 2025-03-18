import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  Map<String, dynamic>? _nutrientData;
  bool isLoading = false;

 

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _nutrientData = null;
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://rajatmalviya-food-classifier-api.hf.space/analyze"),
    );
    request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      setState(() {
        _nutrientData = jsonResponse;
        isLoading = false;
      });
    } else {
      setState(() {
        _nutrientData = {"error": "Failed to process image"};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Food'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_imageFile != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 250,
                          child: Image.file(_imageFile!, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildUploadButton("Click to capture", Icons.camera_alt, Colors.blue, () => _pickImage(ImageSource.camera)),
                          const SizedBox(width: 20),
                          _buildUploadButton("Upload to analyze", Icons.upload, Colors.green, () => _pickImage(ImageSource.gallery)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_nutrientData != null)
                        _buildNutrientData(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Lottie.asset(
                  'lib/assets/animations/running_man.json',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
        ],
      ),
     
    );
  }

  Widget _buildUploadButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return Column(
      children: [
        Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onTap,
        ),
      ],
    );
  }

  Widget _buildNutrientData() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Nutrient Breakdown',
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _nutrientData!.entries.map((entry) => Chip(
              label: Text("${entry.key}: ${entry.value}"),
              backgroundColor: Colors.primaries[_nutrientData!.keys.toList().indexOf(entry.key) % Colors.primaries.length],
              labelStyle: const TextStyle(color: Colors.white),
            )).toList(),
          ),
        ],
      ),
    );
  }
}