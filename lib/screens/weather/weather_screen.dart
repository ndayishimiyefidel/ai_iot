import '../../style.dart';
import 'weather_service.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherData;
  List<Map<String, dynamic>> weeklyForecast = [];

  @override
  void initState() {
    super.initState();
    weatherData = WeatherService().fetchWeatherData('Kigali');
    weatherData.then((data) {
      setState(() {
        weeklyForecast = generateWeeklyForecast(data);
      });
    });
  }

  List<Map<String, dynamic>> generateWeeklyForecast(
      Map<String, dynamic> currentWeather) {
    List<Map<String, dynamic>> forecast = [];
    double currentTemp = currentWeather['main']['temp'];
    double currentHumidity = currentWeather['main']['humidity'];
    String currentDescription = currentWeather['weather'][0]['description'];

    // Basic prediction model: Increment temperature by 1 degree each day and vary humidity.
    for (int i = 1; i <= 5; i++) {
      forecast.add({
        'temp': {'day': (currentTemp + i).toStringAsFixed(1)},
        'humidity': (currentHumidity + i * 2) % 100,
        'weather': [
          {
            'description': currentDescription,
            'icon': currentWeather['weather'][0]['icon']
          }
        ],
      });
    }

    return forecast;
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
              padding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
              child:
                  Text('Today\'s Weather', style: AppStyles.greetingTextStyle),
            ),
            Align(
              alignment: Alignment.center,
              child: WeatherSummary(weatherData: weatherData),
            ),
            SizedBox(height: 20),
            Text('Weekly Forecast',
                style: AppStyles.weatherSummaryTextStyle,
                textAlign: TextAlign.center),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: weeklyForecast.length,
              itemBuilder: (context, index) {
                final dayForecast = weeklyForecast[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Day ${index + 1}', style: AppStyles.dayTextStyle),
                        SizedBox(height: 8),
                        Text('${dayForecast['temp']['day']}°C',
                            style: AppStyles.temperatureTextStyle),
                        SizedBox(height: 4),
                        Text('Humidity: ${dayForecast['humidity']}%',
                            style: AppStyles.humidityTextStyle),
                        SizedBox(height: 4),
                        Image.network(
                            'https://openweathermap.org/img/wn/${dayForecast['weather'][0]['icon']}@2x.png',
                            width: 30,
                            height: 30),
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
                  backgroundImage: AssetImage(
                      'assets/profile.jpg') // Replace with user's profile image URL
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
                    'Mihigo Prince', // Replace with dynamic user name
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
  final Future<Map<String, dynamic>> weatherData;

  WeatherSummary({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading weather data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No weather data available'));
        } else {
          final weather = snapshot.data!;
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
                            'Kigali, Rwanda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '02/July/2024', // Replace with actual date
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Image.network(
                        'https://openweathermap.org/img/wn/${weather['weather'][0]['icon']}@2x.png', // Replace with actual cloud image asset
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
                            '${weather['main']['temp']}°C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Humidity: ${weather['main']['humidity']}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        weather['weather'][0][
                            'description'], // Replace with actual weather condition
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
                    'Plan your day with real-time weather updates. Stay prepared with accurate forecasts, current conditions, and vital information at your fingertips. Be weather-ready with us.',
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
      },
    );
  }
}
