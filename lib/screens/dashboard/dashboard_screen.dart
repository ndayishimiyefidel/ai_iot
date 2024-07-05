import '../../style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  final String email;

  const DashboardScreen({super.key, required this.email});
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'User';
    final profileImage =
        prefs.getString('profileImage') ?? 'assets/profile.jpg';
    return {'username': username, 'profileImage': profileImage};
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
              padding: EdgeInsets.only(
                  left: 10.0,
                  top: 20.0,
                  bottom: 20.0), // Adjust top and bottom margin as needed
              child: Text(
                'Today\'s Weathers',
                style: AppStyles.greetingTextStyle,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: WeatherSummary(),
            ),
            Farm(),
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
                    NetworkImage(profileImage), // Use user's profile image URL
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
              Icon(Icons.more_vert, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherSummary extends StatelessWidget {
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
        child: Column(
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
                      'Kigali, Rwanda',
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
                  'assets/weather_icon.png', // Replace with actual cloud image asset
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
                      '25°C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.0), // Reduced height
                    Text(
                      'Humidity: 60%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0, // Reduced font size
                      ),
                    ),
                  ],
                ),
                Text(
                  'Cloudy', // Replace with actual weather condition
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
              'Weather condition description or time info', // Replace with actual weather info text
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0, // Reduced font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Farm extends StatelessWidget {
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
            'assets/farm.jpg', // Replace with your farm image asset
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.0),
          Text(
            'This is a description of the farm. Here you can provide more details about the farm and its significance.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
