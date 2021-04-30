

import 'package:firebasetest/actions/ActionWeather.dart';
import 'package:firebasetest/components/GenerateWeatherPanel.dart';
import 'package:firebasetest/config/Urls.dart';
import 'package:firebasetest/models/WeatherForcast.dart';
import 'package:flutter/material.dart';

class WeatherWidget extends StatefulWidget {
  final Future<WeatherForcast> weather_data;
  WeatherWidget({Key key, this.weather_data}) : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final double widgetPaddingVert = 10;
  final String iconSize = "4x";
  @override
  Widget build(BuildContext context) {
  
    return Container(
      height: 75,
      alignment: Alignment.center,
      child: Center(
        child: FutureBuilder(
          future: widget.weather_data,
          builder: (context, snapshot) {
            print('snapshot has data : ${snapshot.hasData}');
            if (snapshot.hasData) {
              LinearGradient widgetColor =
                  GenerateWeatherPanel.getWeatherGradient(snapshot.data.weather[0].id);
              String icon = snapshot.data.weather[0].icon;
              return Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10),
                    gradient: widgetColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                      padding:
                          EdgeInsets.symmetric(vertical: widgetPaddingVert),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(2),
                              child: Image.network(
                                  '${Urls.weather_icon}$icon@$iconSize.png')),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${snapshot.data.weather[0].main}'
                                  ' ${snapshot.data.main.temp.toInt()}'
                                  ' C',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Text(
                                    snapshot.data.name +
                                        ',' +
                                        snapshot.data.name,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              
                  ],
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}