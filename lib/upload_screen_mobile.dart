// upload_screen_mobile.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<File?> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Widget displayImage(File? imageFile) {
  return imageFile != null
      ? Image.file(imageFile, height: 200)
      : Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.add_a_photo, size: 100, color: Colors.grey),
        );
}
