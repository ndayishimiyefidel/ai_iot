import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Widget displayImage(File? imageFile) {
  return imageFile != null
      ? Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                10), // If you want to clip the image within the rounded corners
            child: Image.file(
              imageFile,
              fit: BoxFit.cover, // Use BoxFit.cover to fill the container
            ),
          ),
        )
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
