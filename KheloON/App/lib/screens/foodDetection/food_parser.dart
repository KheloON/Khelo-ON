import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FoodDetectionScreen extends StatefulWidget {
  @override
  _FoodDetectionScreenState createState() => _FoodDetectionScreenState();
}

class _FoodDetectionScreenState extends State<FoodDetectionScreen> {
  File? _image;
  final picker = ImagePicker();
  String? _selectedOption;
  bool _isLoading = false;
  Map<String, dynamic>? _response;

  final String apiUrl = "https://rajatmalviya-food-classifier-api.hf.space/analyze";
  final List<String> options = [
    "detect_allergens",
    "detailed_nutrient_info",
    "learn_about_food",
    "fun_facts",
    "generate_dish"
  ];

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> analyzeFood() async {
    if (_image == null || _selectedOption == null) return;
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    request.fields['analysis_type'] = _selectedOption!;

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    setState(() {
      _isLoading = false;
      _response = json.decode(responseData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Detection"),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          IconButton(
            icon: Icon(Icons.restaurant),
            onPressed: () {
              Navigator.pushNamed(context, '/dietplan');
            },
          ),
          IconButton(
            icon: Icon(Icons.details),
            onPressed: () {
              Navigator.pushNamed(context, '/plandetails');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () => getImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.upload),
                onPressed: () => getImage(ImageSource.gallery),
              ),
            ],
          ),
          if (_image != null) Image.file(_image!),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: options.map((option) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedOption = option;
                  });
                },
                child: Text(option.replaceAll('_', ' ').toUpperCase()),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: analyzeFood,
            child: Text("Analyze"),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Lottie.asset('lib/assets/animations/running_man.json'),
              ),
            ),
          if (_response != null)
            Expanded(
              child: ListView(
                children: _response!.entries.map((entry) {
                  return Card(
                    child: ListTile(
                      title: Text(entry.key.toUpperCase()),
                      subtitle: Text(entry.value.toString()),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
