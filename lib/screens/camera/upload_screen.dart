import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb2

// Conditional imports
import 'upload_screen_mobile.dart' if (dart.library.html) 'upload_screen_web.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  dynamic _image;

  Future<void> _pickImage() async {
    final image = await pickImage();
    setState(() {
      _image = image;
    });
  }

  void _uploadImageToFirebase() {
    // Implement Firebase storage upload logic here
    // Example: FirebaseStorage.instance.ref().child('uploads/image.jpg').putFile(_imageFile!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image uploaded to Firebase!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: displayImage(_image),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _image != null ? _uploadImageToFirebase : null,
              icon: Icon(Icons.cloud_upload),
              label: Text('Upload to Firebase'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: Colors.lightBlue,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
