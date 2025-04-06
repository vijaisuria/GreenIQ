import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PestDetection extends StatefulWidget {
  @override
  _PestDetectionState createState() => _PestDetectionState();
}

class _PestDetectionState extends State<PestDetection> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  String _result = "";
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = pickedFile;
        _result = "";
      });
    }
  }

  Future<void> _uploadAndPredict() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _result = "";
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:5000/predict"),
    );
    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedFile!.path),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);
        setState(() {
          _result = "${json['class']}";
        });
      } else {
        setState(() {
          _result = "Prediction failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: Could not connect to the server.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome Text
              Text(
                "Welcome to GreenGuardAI",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                "Upload your image to detect pests or diseases",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Image Rendering or Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedFile!.path),
                    fit: BoxFit.cover,
                  ),
                )
                    : Center(
                  child: Text(
                    "No image selected",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Buttons for Camera and Upload
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text("Camera"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo),
                    label: Text("Upload"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Send Button
              ElevatedButton(
                onPressed: _selectedFile != null && !_isLoading ? _uploadAndPredict : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isLoading
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Analyzing..."),
                  ],
                )
                    : Text("Analyse"),
              ),
              SizedBox(height: 20),
              // Results Section
              if (_result.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}