import 'dart:io';
import 'upload_screen_mobile.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb2
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Conditional imports

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  dynamic _image;
  File? _imageFile;
  bool _isUploading = false;
  late List _results = [];
  late SharedPreferences preferences;

  String? currentuserid;
  String? userRole, name, email, phone;

  void getCurrentUser() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      currentuserid = preferences.getString("uid");
      name = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  String? street;
  String? city;
  String? country;
  String? postalCode;
  String? state, streetName;
  double? latitudeValue;
  double? longitudeValue;

  // Function to fetch the current location and address
  Future<void> getCurrentLocation() async {
    try {
      // Request permission to access the device's location
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denied location access
        return;
      }
      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use the geocoding package to convert coordinates into address information
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placeMarks.isNotEmpty) {
        latitudeValue = position.latitude;
        longitudeValue = position.longitude;
        Placemark placeMark = placeMarks[0];

        // Access address components
        streetName = placeMark.name;
        street = placeMark.street;
        city = placeMark.locality;
        state = placeMark.administrativeArea;
        country = placeMark.country;
        postalCode = placeMark.postalCode;
      }
    } catch (e) {
      // Handle errors such as no GPS signal, location services disabled, etc.
      if (kDebugMode) {
        print("Error getting location: $e");
      }
    }
  }

  // Load the TensorFlow Lite model
  // Future loadModel() async {
  //   //Tflite.close();
  //   String res;
  //   res = (await Tflite.loadModel(
  //     model: "assets/ai_rice_trained_model.tflite",
  //     labels: "assets/labels.txt",
  //   ))!;
  //   if (kDebugMode) {
  //     print("Models loading status: $res");
  //   }
  // }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/ai_rice_trained_model.tflite",
        labels: "assets/labels.txt",
      );
      print("Model loaded: $res");
    } on Exception catch (e) {
      print('Failed to load model: $e');
    }
  }

  // Function to classify an image
  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 8,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
    });
  }

  Future<void> _pickImage() async {
    final image = await pickImage();
    setState(() {
      _image = image;
    });
  }

  Future<void> _uploadImageToFirebase() async {
    setState(() {
      _isUploading = true;
    });

    // Delay before classifying the image (for demonstration purposes)
    await Future.delayed(const Duration(seconds: 6));
    await imageClassification(_image!);

    // Upload image to Firebase Storage
    String originalImageName = _image!.path.split('/').last;
    String currentDateTime = DateTime.now().toString();
    String imageName = '$originalImageName-$currentDateTime';
    firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(imageName);
    await storageRef.putFile(_imageFile!);

    // Get the image URL from Firebase Storage
    String imageUrl = await storageRef.getDownloadURL();

    // Get the current user's ID
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;

    // Save image details to Cloud Firestore
    DocumentReference resultRef =
        await FirebaseFirestore.instance.collection('capturedData').add({
      'userId': userId, // Save the user ID along with the image details
      'imageUrl': imageUrl,
      'createdAt': currentDateTime,
      'detectedValue': _results[0]['confidence'],
      'detectedLabel': _results[0]['label'],
      'street': street,
      'city': city,
      'country': country,
      "username": name,
      "email": email,
      "latitude": latitudeValue,
      "longitude": longitudeValue
    });
    setState(() {
      _isUploading = false;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DetectedImagesPage(
      //       userRole: userRole.toString(),
      //     ),
      //   ),
      // );
    });

    // Update the plastic detection status
  }

  Future<void> showLocationDisclosureDialog() async {
    // Show the custom location disclosure dialog
    bool? userAccepted = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return LocationDisclosureDialog(
          onPermissionChoice: (accepted) {
            Navigator.of(context)
                .pop(accepted); // Close the dialog and pass the choice
          },
        );
      },
    );

    if (userAccepted == true) {
      // User accepted location permission, call getCurrentLocation
      await getCurrentLocation();
    } else {
      // User closed the dialog without making a choice
      // Handle this case as needed

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission was denied or not granted.'),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadModel();
    //load inter
    Future.delayed(Duration.zero, () {
      showLocationDisclosureDialog();
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                '\n1. Tap the image below to pick an image from your gallery.\n2. Once the image is selected, tap "Detect Disease" to analyze the image.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: displayImage(_image),
            ),
            SizedBox(height: 20),
            !_isUploading
                ? ElevatedButton.icon(
                    onPressed: _image != null ? _uploadImageToFirebase : null,
                    icon: Icon(Icons.cloud_upload),
                    label: Text('Detect Disease'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      backgroundColor: Colors.lightBlue,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}

class LocationDisclosureDialog extends StatelessWidget {
  final Function(bool) onPermissionChoice;

  const LocationDisclosureDialog({super.key, required this.onPermissionChoice});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Access Required'),
      content: const Text(
        'Rice AI Detection App needs access to your location to know where the parcel located that can used in reporting for place with high concentrations.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Navigator.of(context).pop(); // Close the dialog
            onPermissionChoice(true); // User accepted permission
          },
          child: const Text('Accept'),
        ),
        TextButton(
          onPressed: () {
            // Navigator.of(context).pop(); // Close the dialog
            onPermissionChoice(false); // User denied permission
          },
          child: const Text('Deny'),
        ),
      ],
    );
  }
}
