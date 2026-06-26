import 'dart:convert';
import 'dart:io';

import 'deps/flutter_clock_helper/model.dart';

class WeatherData {
  final String city;
  final double tempC;
  final double highC;
  final double lowC;
  final WeatherCondition condition;

  const WeatherData({
    required this.city,
    required this.tempC,
    required this.highC,
    required this.lowC,
    required this.condition,
  });
}

WeatherCondition _mapCode(int code) {
  if (code == 113) return WeatherCondition.sunny;
  if (code == 116 || code == 119 || code == 122) return WeatherCondition.cloudy;
  if (code == 143 || code == 248 || code == 260) return WeatherCondition.foggy;
  if (code >= 200 && code < 300) return WeatherCondition.thunderstorm;
  if (code >= 300 && code < 400) return WeatherCondition.rainy;
  if (code >= 500 && code < 600) return WeatherCondition.rainy;
  if (code >= 600 && code < 700) return WeatherCondition.snowy;
  if (code == 386 || code == 389 || code == 392 || code == 395) {
    return WeatherCondition.thunderstorm;
  }
  if (code >= 362 && code < 395) return WeatherCondition.rainy;
  return WeatherCondition.cloudy;
}

class WeatherService {
  static WeatherData? _cached;
  static DateTime? _fetchedAt;

  static Future<WeatherData?> fetch() async {
    final now = DateTime.now();
    if (_cached != null &&
        _fetchedAt != null &&
        now.difference(_fetchedAt!).inMinutes < 10) {
      return _cached;
    }
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 8);
      final req = await client
          .getUrl(Uri.parse('http://wttr.in/?format=j1'))
          .timeout(const Duration(seconds: 10));
      req.headers.set('User-Agent', 'curl/7.68.0');
      final res = await req.close().timeout(const Duration(seconds: 10));
      final body = await res.transform(utf8.decoder).join();
      client.close();

      final json = jsonDecode(body) as Map<String, dynamic>;
      final area = (json['nearest_area'] as List).first as Map<String, dynamic>;
      final city = ((area['areaName'] as List).first as Map)['value'] as String;
      final cond =
          (json['current_condition'] as List).first as Map<String, dynamic>;
      final tempC = double.parse(cond['temp_C'] as String);
      final code = int.parse(cond['weatherCode'] as String);
      final weather = (json['weather'] as List).first as Map<String, dynamic>;
      final maxC = double.parse(weather['maxtempC'] as String);
      final minC = double.parse(weather['mintempC'] as String);

      _cached = WeatherData(
        city: city,
        tempC: tempC,
        highC: maxC,
        lowC: minC,
        condition: _mapCode(code),
      );
      _fetchedAt = now;
      return _cached;
    } catch (_) {
      return _cached;
    }
  }
}
