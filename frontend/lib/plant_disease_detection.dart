import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PlantDiseaseDetection extends StatefulWidget {
  @override
  _PlantDiseaseDetectionState createState() => _PlantDiseaseDetectionState();
}

class _PlantDiseaseDetectionState extends State<PlantDiseaseDetection> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _detectDisease() {
    // Call your plant disease detection API or logic here
    print('Disease detection logic goes here.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Detection'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_image != null)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                      'No Image Selected',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Capture Image'),
                      onPressed: _pickImageFromCamera,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between buttons
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.image),
                      label: Text('Upload Image'),
                      onPressed: _pickImageFromGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _image != null ? _detectDisease : null,
                child: Text('Detect Disease'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _image != null ? Colors.green : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              if (_image != null)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detected Disease:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No disease detected',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
