import 'package:flutter/material.dart';

class AppStyles {
  static const EdgeInsets imageMargin = EdgeInsets.all(8.0);
  static const TextStyle greetingTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle weatherSummaryTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
  static const Color topNavBackgroundColor = Color(0xFFF8F8F8);
  static const TextStyle topNavTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
  );
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const Border contentBorder = Border(
    top: BorderSide(color: Colors.grey, width: 1.0),
    bottom: BorderSide(color: Colors.grey, width: 1.0),
  );
  static const EdgeInsets contentMargin = EdgeInsets.all(10.0);

  static const TextStyle loginTitleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
  );

  static final InputDecoration kTextFieldDecoration = InputDecoration(
    labelText: 'Enter your value',
    labelStyle: TextStyle(color: Colors.blueAccent),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle kButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static const TextStyle kLinkStyle = TextStyle(
    fontSize: 14,
    color: Colors.blueAccent,
    decoration: TextDecoration.underline,
  );

  // Add these new text styles
  static const TextStyle dayTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle temperatureTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle humidityTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );
}

