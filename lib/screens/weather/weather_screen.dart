import 'package:flutter/material.dart';
import '../../style.dart';

class WeatherScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopNav(),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0,
                  top: 20.0,
                  bottom: 20.0), // Adjust top and bottom margin as needed
              child: Text(
                'Today\'s Weather',
                style: AppStyles.greetingTextStyle,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: WeatherSummary(),
            ),
            SizedBox(height: 20),
            Text(
              'Weekly Forecast',
              style: AppStyles.weatherSummaryTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Day ${index + 1}', style: AppStyles.dayTextStyle),
                        SizedBox(height: 8),
                        Text('25°C', style: AppStyles.temperatureTextStyle),
                        SizedBox(height: 4),
                        Text('Humidity: 60%',
                            style: AppStyles.humidityTextStyle),
                        SizedBox(height: 4),
                        Image.network('assets/weather_icon.png',
                            width: 30,
                            height: 30), // Replace with actual weather icon URL
                      ],
                    ),
                  ),
                );
              },
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
              icon: Icon(Icons.agriculture),
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
                backgroundImage: NetworkImage(
                  'assets/profile.jpg', // Replace with user's profile image URL
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome back ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    'Mihigo Prince ', // Replace with dynamic user name
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
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.all(20.0),
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
                      'kigali ,  Rwanda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '02/july/2024', // Replace with actual date
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Image.network(
                  'assets/weather_icon.png', // Replace with actual cloud image asset
                  width: 120,
                  height: 80,
                ),
              ],
            ),
            SizedBox(height: 10.0),
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
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Humidity: 60%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Cloudy', // Replace with actual weather condition
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Divider(
              color: Colors.white,
              height: 20.0,
              thickness: 1.0,
            ),
            SizedBox(height: 10.0),
            Text(
              'Weather condition description or time info', // Replace with actual weather info text
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
