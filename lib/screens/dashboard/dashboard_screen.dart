import 'dart:convert';
import '../../style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  final String email;

  const DashboardScreen({super.key, required this.email});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Future<Map<String, String>> _getUserInfo() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(user.uid)
  //         .get();
  //     final username = userDoc.get('username') ?? 'User';
  //     final profileImage = userDoc.get('profileImage') ?? 'assets/profile.jpg';
  //     return {'username': username, 'profileImage': profileImage};
  //   } else {
  //     return {'username': 'User', 'profileImage': 'assets/profile.jpg'};
  //   }
  // }

  Future<Map<String, String>> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? profileImage =
        prefs.getString('profileImage') ?? 'assets/profile.jpg';

    return {
      'username': username ?? 'User',
      'email': email ?? 'example@example.com',
      'profileImage': profileImage
    };
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, String>>(
              future: _getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final userInfo = snapshot.data ??
                    {'username': 'User', 'profileImage': 'assets/profile.jpg'};
                return TopNav(
                    username: userInfo['username']!,
                    profileImage: userInfo['profileImage']!);
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
              child: Text(
                'Today\'s Weather',
                style: AppStyles.greetingTextStyle,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: WeatherSummary(),
            ),
            Farm(
              imageUrl: 'assets/bg1.jpg',
              description: 'This plant is healthy.',
            ),
            Farm(
              imageUrl: 'assets/bg2.jpg',
              description: 'This plant has a disease: blight.',
            ),
            Farm(
              imageUrl: 'assets/bg3.jpg',
              description: 'This plant has a disease: powdery mildew.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            IconButton(
              icon: Icon(Icons.cloud),
              onPressed: () {
                Navigator.pushNamed(context, '/weather');
              },
            ),
            IconButton(
              icon: Icon(Icons.analytics),
              onPressed: () {
                Navigator.pushNamed(context, '/farm');
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/my_account');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TopNav extends StatelessWidget {
  final String username;
  final String profileImage;

  TopNav({required this.username, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyles.topNavBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    AssetImage(profileImage), // Use user's profile image URL
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    username, // Use dynamic user name
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.black),
              SizedBox(width: 20), // Adjust the width as needed
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherSummary extends StatefulWidget {
  @override
  _WeatherSummaryState createState() => _WeatherSummaryState();
}

class _WeatherSummaryState extends State<WeatherSummary> {
  Future<Map<String, dynamic>>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = fetchWeather();
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    final apiKey = '9956b1377288ea2cc1ba3db978698eba';
    final city = "Kigali";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9, // 90% of the parent's width
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0), // Reduced bottom margin
        padding: EdgeInsets.all(15.0), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.lightBlue, // Background color
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load weather data'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No weather data available'));
            } else {
              final weatherData = snapshot.data!;
              final cityName = weatherData['name'];
              final temp = weatherData['main']['temp'].toString();
              final humidity = weatherData['main']['humidity'].toString();
              final weatherMain = weatherData['weather'][0]['main'];
              final weatherDescription =
                  weatherData['weather'][0]['description'];
              final iconCode = weatherData['weather'][0]['icon'];
              final weatherIconUrl =
                  "https://openweathermap.org/img/wn/$iconCode.png";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$cityName, Rwanda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0, // Reduced font size
                            ),
                          ),
                          SizedBox(height: 3.0), // Reduced height
                          Text(
                            '02/July/2024', // Replace with actual date
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0, // Reduced font size
                            ),
                          ),
                        ],
                      ),
                      Image.network(
                        weatherIconUrl, // Weather icon from API
                        width: 100,
                        height: 60,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0), // Reduced height
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temp°C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0, // Reduced font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3.0), // Reduced height
                          Text(
                            'Humidity: $humidity%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0, // Reduced font size
                            ),
                          ),
                        ],
                      ),
                      Text(
                        weatherMain,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0), // Reduced height
                  Divider(
                    color: Colors.white,
                    height: 10.0,
                    thickness: 1.0,
                  ),
                  SizedBox(height: 5.0), // Reduced height
                  Text(
                    weatherDescription, // Replace with actual weather info text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0, // Reduced font size
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class Farm extends StatelessWidget {
  final String imageUrl;
  final String description;

  Farm({required this.imageUrl, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Farm',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Image.asset(
            imageUrl, // Replace with your farm image asset
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
