import 'package:firebase_database/firebase_database.dart';
import 'package:firebasetest/actions/ActionWeather.dart';
import 'package:firebasetest/components/DeviceCard.dart';
import 'package:firebasetest/components/Weather.dart';
import 'package:firebasetest/main.dart';
import 'package:firebasetest/models/WeatherForcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'sal.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ShowDB extends StatefulWidget {
  @override
  _ShowDBState createState() => _ShowDBState();
}

class _ShowDBState extends State<ShowDB> with SingleTickerProviderStateMixin {
  Future<WeatherForcast> weatherModel;
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  TabController _tabController;
  int tabIndex = 0;
  DatabaseReference firebaseData =
      FirebaseDatabase.instance.reference().child('DHT/Json');

  void initialNotification() {
    message = "No message.";

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
  }

  @override
  void initState() {
    // getWeather();
    weatherModel =
        ActionWeather.weather(lat: 7.893977314032773, lng: 98.35261457403632);
    initialNotification();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  sendNotification({String title, String detail}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(111, '$title', '$detail', platformChannelSpecifics, payload: 's');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Quality'),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
              stream: firebaseData.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data.snapshot.value != null) {
                  print("${snapshot.data.snapshot.value.toString()}");
                  var _show = SAL.fromJson(snapshot.data.snapshot.value);
                  print("SAL : ${_show.temp} / ${_show.ec} / ${_show.sal}");
                  if (_show.sal > 30) {
                    sendNotification(
                        title: 'Caution!',
                        detail: 'Salinity Too Much! ${_show.sal.floor()} ppt');
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text('Weather',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: WeatherWidget(
                                weather_data: weatherModel,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text('Water',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                        DeviceCard(
                          // item: '// item: 'Temperature',',
                          item :Text('Temperature'),
                          value: _show.temp,
                          postFix: "C",
                        ),
                        DeviceCard(
                          item :Text('Salinity'),
                          value: _show.sal,
                          postFix: 'PPT',
                        ),
                        DeviceCard(
                          item :Text('EC'),
                          value: _show.ec,
                          postFix: "uS/m",
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text("No Data"));
                }
              }),
        ),
      ),
    );
  }
}
