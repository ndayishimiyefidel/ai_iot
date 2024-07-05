import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return pickedFile.path;
  }
  return null;
}

Widget displayImage(String? imageUrl) {
  return imageUrl != null
      ? Image.network(imageUrl, height: 200)
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
