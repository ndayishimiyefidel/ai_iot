import 'dart:io';
import './style.dart';
import 'package:flutter/material.dart';
import 'package:ai_iot/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_iot/screens/camera/upload_screen_mobile.dart';

// if (dart.library.html) 'upload_screen_web.dart';

// Conditional imports

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _profileImage;
  String _message = '';
  bool isloading = false;

  Future<void> _pickImage() async {
    final image = await pickImage();
    setState(() {
      _profileImage = image;
    });
  }

  // Future<void> _register() async {
  //   if (_passwordController.text != _confirmPasswordController.text) {
  //     setState(() {
  //       _message = 'Passwords do not match';
  //     });
  //     return;
  //   }
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('username', _usernameController.text);
  //     await prefs.setString('email', _emailController.text);
  //     await prefs.setString('password', _passwordController.text);

  //     Fluttertoast.showToast(
  //       msg: 'Registration successful!',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );

  //     await Future.delayed(Duration(seconds: 3));
  //     Navigator.pushReplacementNamed(context, '/login');
  //   } catch (error) {
  //     setState(() {
  //       _message = 'Registration failed. Please try again.';
  //     });
  //   }
  // }
  void _registerUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //get device id
    if (_formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      preferences = await SharedPreferences.getInstance();
      var firebaseUser = FirebaseAuth.instance.currentUser;
      await _auth
          .createUserWithEmailAndPassword(
              email: _emailController.text.toString().trim(),
              password: _passwordController.text.toString().trim())
          .then((auth) async {
        firebaseUser = auth.user;
      }).catchError((err) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message)));
      });

      if (firebaseUser != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection("Users")
            .where("uid", isEqualTo: firebaseUser!.uid)
            .get();

        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(firebaseUser!.uid)
              .set({
            "uid": firebaseUser!.uid,
            "email": firebaseUser!.email,
            "username": _usernameController.text.toString().trim(),
            // "phone": phoneNumber.trim(),
            // "userRole": "User",
            "password": _passwordController.text.trim(),
            // "photoUrl": defaultPhotoUrl,
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "state": 1,
          });
          final currentuser = firebaseUser;
          await preferences.setString("uid", currentuser!.uid);
          await preferences.setString(
              "name", _usernameController.text.toString().trim());
          // await preferences.setString("photo", defaultPhotoUrl);
          // await preferences.setString("phone", phoneNumber.trim());
          await preferences.setString("email", currentuser.email.toString());
          //  await preferences.setString("UserRole", "User");
        } else {
          //get user detail for current user
          await preferences.setString("uid", documents[0]["uid"]);
          await preferences.setString("username", documents[0]["username"]);
          // await preferences.setString("photo", documents[0]["photoUrl"]);
          // await preferences.setString("phone", documents[0]["phone"]);
          await preferences.setString("email", documents[0]["email"]);
          // await preferences.setString("UserRole", documents[0]["userRole"]);
          setState(() {
            isloading = false;
          });
          Fluttertoast.showToast(
              msg:
                  "Account with this credentials is already created or this device is already in use");
        }

        setState(() {
          isloading = false;
        });
        Route route = MaterialPageRoute(builder: (c) => const LoginScreen());
        setState(() {
          Navigator.push(context, route);
        });
      } else {
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(msg: "Sign up Failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Register',
                    style: AppStyles.loginTitleTextStyle.copyWith(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account by filling in the details below',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: _profileImage != null
                                ? (_profileImage is File
                                    ? FileImage(_profileImage as File)
                                    : NetworkImage(_profileImage as String)
                                        as ImageProvider)
                                : null,
                            child: _profileImage == null
                                ? const Icon(Icons.add_a_photo)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Username',
                            hintText: 'Enter your username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Confirm Password',
                            hintText: 'Confirm your password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: AppStyles.kButtonStyle,
                            onPressed: _registerUser,
                            child: const Text('Register'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                height: 36,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Register with',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                height: 36,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Implement Google sign-in
                              },
                              child: Image.asset(
                                'assets/google.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                // Implement Apple sign-in
                              },
                              child: Image.asset(
                                'assets/icloud.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                // Implement Facebook sign-in
                              },
                              child: Image.asset(
                                'assets/facebook.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Already have an account? Login',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
