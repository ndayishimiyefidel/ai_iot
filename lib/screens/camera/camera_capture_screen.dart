import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraCaptureScreen extends StatefulWidget {
  @override
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _imageFile; // Declare _imageFile as nullable XFile

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final picturePath = await _getPicturePath(); // Ensure picturePath is correctly obtained
      if (picturePath != null) {
        final image = await _controller.takePicture();
        setState(() {
          _imageFile = XFile(image.path); // Update _imageFile with XFile
        });
        _showAlert('Picture Taken', 'Image saved at ${image.path}');
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<String?> _getPicturePath() async {
    final directory = await getTemporaryDirectory();
    if (directory != null) {
      return path.join(directory.path, '${DateTime.now()}.png');
    }
    return null;
  }

  Future<void> _saveFile(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final base64Data = base64Encode(bytes);
    // Here you can handle saving or further processing of the base64 data
    print('Base64 Data: $base64Data');
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GalleryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Photo'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: _navigateToGallery,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview
            return _controller.value.isInitialized
                ? Stack(
                    children: [
                      CameraPreview(_controller),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: IconButton(
                            onPressed: _takePicture,
                            icon: Icon(Icons.camera, size: 50.0, color: Colors.white),
                          ),
                        ),
                      ),
                      _imageFile != null
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Image.file(File(_imageFile!.path)),
                                    SizedBox(height: 10),
                                    IconButton(
                                      onPressed: () {
                                        _saveFile(_imageFile!.path); // Save file
                                      },
                                      icon: Icon(Icons.save, size: 30.0),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Center(
        child: Text('Gallery Screen'),
      ),
    );
  }
}