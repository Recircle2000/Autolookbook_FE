import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

IconData? getWeatherIcon(String condition) {
  switch (condition) {
    case "비":
      return WeatherIcons.rain;
    case "비/눈":
      return WeatherIcons.rain_mix;
    case "눈":
      return WeatherIcons.snow;
    case "소나기":
      return WeatherIcons.showers;
    case "맑음":
      DateTime now = DateTime.now();
      bool isMorning = now.hour >= 6 && now.hour < 18;
      return isMorning ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
    case "구름많음":
      return WeatherIcons.cloud;
    case "흐림":
      return WeatherIcons.cloudy;
    default:
      return null;
  }
}