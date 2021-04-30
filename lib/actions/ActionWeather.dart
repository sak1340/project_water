
import 'package:dio/dio.dart';
import 'package:firebasetest/config/Urls.dart';
import '../models/WeatherForcast.dart';
class ActionWeather {
  static Future<WeatherForcast> weather({double lat, double lng}) async {
    print('lat $lat lng $lng');
    Dio weather = Dio(BaseOptions(baseUrl: Urls.weather));
    final result = await weather.get(
      '',
      queryParameters: {
        "lat": lat,
        "lon": lng,
        "appid": "6157ce9f9cedbfa12799870b6cb940cf",
      },
    );

    return WeatherForcast.fromJson(result.data);
  }
}