import 'package:flutter/material.dart';

class GenerateWeatherPanel {
  static LinearGradient getWeatherGradient(int weatherId) {
    LinearGradient widgetColor;
    if (weatherId == 800) {
      // Clear
      widgetColor = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[300],
            Colors.blue[400],
            Colors.blue[500],
            Colors.blue[600],
            Colors.blue[700],
          ]);
    } else if (weatherId >= 200 && weatherId <= 232) {
      // Thunderstorm
      widgetColor = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black45,
            Colors.black87,
          ]);
    } else if (weatherId >= 300 && weatherId <= 321) {
      // Drizzle
      widgetColor = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.indigo[300],
            Colors.indigo[400],
            Colors.indigo[500],
            Colors.indigo[600],
            Colors.indigo[700],
          ]);
    } else if (weatherId >= 500 && weatherId <= 531) {
      // Rain
      widgetColor = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueGrey[100],
            Colors.blueGrey[400],
            Colors.blueGrey[500],
          ]);
    } else if (weatherId >= 701 && weatherId <= 781) {
      // Atmosphere Group
      widgetColor = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orangeAccent[100],
            Colors.orangeAccent[400],
            Colors.orangeAccent[700],
          ]);
    } else if (weatherId >= 801 && weatherId <= 804) {
      // Cloud
      widgetColor = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue[300],
            Colors.lightBlue[400],
            Colors.lightBlue[500],
            Colors.lightBlue[600],
            Colors.lightBlue[700],
          ]);
    }
    return widgetColor;
  }
}