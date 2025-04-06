import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDataScreen extends StatefulWidget {
  const ProfileDataScreen({Key? key}) : super(key: key);

  @override
  _ProfileDataScreenState createState() => _ProfileDataScreenState();
}

class _ProfileDataScreenState extends State<ProfileDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _image;

  String? name, gender, bloodGroup, address, sport, hobbies;
  DateTime? dob;
  int? age, height, weight;

  // pick image
  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String?> _uploadPhoto(String uid) async {
    if (_image == null) return null;
    final ref = FirebaseStorage.instance.ref().child('user_photos/$uid.jpg');
    await ref.putFile(_image!);
    return await ref.getDownloadURL();
  }

 Future<void> _submitProfile() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? photoUrl = await _uploadPhoto(user.uid);

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': name,
      'dob': dob?.toIso8601String(),
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
      'address': address,
      'sport': sport,
      'hobbies': hobbies,
      'photoUrl': photoUrl,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );

    // Navigate to MainScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.add_a_photo) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              onSaved: (val) => name = val,
              validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
              onSaved: (val) => age = int.tryParse(val!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Gender"),
              onSaved: (val) => gender = val,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Height (cm)"),
              keyboardType: TextInputType.number,
              onSaved: (val) => height = int.tryParse(val!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Weight (kg)"),
              keyboardType: TextInputType.number,
              onSaved: (val) => weight = int.tryParse(val!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Blood Group"),
              onSaved: (val) => bloodGroup = val,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Address"),
              onSaved: (val) => address = val,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Sport"),
              onSaved: (val) => sport = val,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Hobbies"),
              onSaved: (val) => hobbies = val,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: const Text("Save Profile"),
            ),
          ]),
        ),
      ),
    );
  }
}
