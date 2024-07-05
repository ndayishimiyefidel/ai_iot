import './style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_iot/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String _message = '';
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Future<void> _login() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? storedEmail = prefs.getString('email');
  //     String? storedPassword = prefs.getString('password');

  //     if (_emailController.text == storedEmail &&
  //         _passwordController.text == storedPassword) {
  //       if (_rememberMe) {
  //         prefs.setString('email', _emailController.text);
  //         prefs.setString('password', _passwordController.text);
  //       } else {
  //         prefs.remove('email');
  //         prefs.remove('password');
  //       }

  //       Fluttertoast.showToast(
  //         msg: 'Login successful!',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //       Navigator.pushReplacementNamed(context, '/dashboard');
  //     } else {
  //       setState(() {
  //         _message = 'Invalid email or password';
  //       });
  //     }
  //   } catch (error) {
  //     setState(() {
  //       _message = 'Login failed. Please try again.';
  //     });
  //   }
  // }

  void loginUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      preferences = await SharedPreferences.getInstance();

      var user = FirebaseAuth.instance.currentUser;

      await _auth
          .signInWithEmailAndPassword(
              email: _emailController.text.toString().trim(),
              password: _passwordController.text.trim())
          .then((auth) {
        user = auth.user;
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message)));
      });

      if (user != null) {
        FirebaseFirestore.instance
            .collection("userlist")
            .doc(user!.uid)
            .update({"state": 1});

        FirebaseFirestore.instance
            .collection("userlist")
            .doc(user!.uid)
            .get()
            .then((datasnapshot) async {
          await preferences.setString("uid", datasnapshot.data()!["uid"]);
          await preferences.setString(
              "username", datasnapshot.data()!["username"]);
          // await preferences.setString(
          //     "photo", datasnapshot.data()!["photoUrl"]);
          await preferences.setString("email", datasnapshot.data()!["email"]);
          // await preferences.setString("phone", datasnapshot.data()!["phone"]);
          // await preferences.setString(
          //     "userRole", datasnapshot.data()!["userRole"]);

          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Account created successfully",
              textColor: Colors.red,
              fontSize: 18);
          Route route = MaterialPageRoute(
              builder: (c) => DashboardScreen(
                    email: _emailController.text.toString().trim(),
                  ));
          setState(() {
            Navigator.push(context, route);
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Login Failed,No such user matching with your credentials",
            textColor: Colors.red,
            fontSize: 18);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'AI-Based Disease Detection System for Rice Crops',
                  style: AppStyles.loginTitleTextStyle.copyWith(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your account to access the system',
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
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text('Remember Me'),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // Implement forgot password functionality
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: AppStyles.kButtonStyle,
                            onPressed: loginUser,
                            child: const Text('Login'),
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
                                'Login with',
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
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text(
                                'Don\'t have an account? Register',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
