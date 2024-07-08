import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '9956b1377288ea2cc1ba3db978698eba';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse('$apiUrl/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchWeeklyForecast(String city) async {
    final response = await http.get(Uri.parse('$apiUrl/forecast/daily?q=$city&appid=$apiKey&units=metric&cnt=7'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['list']);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
