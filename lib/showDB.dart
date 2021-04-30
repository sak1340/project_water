import 'package:firebase_database/firebase_database.dart';
import 'package:firebasetest/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'sal.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ShowDB extends StatefulWidget {
  @override
  _ShowDBState createState() => _ShowDBState();
}

class _ShowDBState extends State<ShowDB> with SingleTickerProviderStateMixin {

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
        android : initializationSettingsAndroid, iOS:  initializationSettingsIOS);
 
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
        android : androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
 
    await flutterLocalNotificationsPlugin.show(111, '$title',
        '$detail', platformChannelSpecifics,
        payload: 's');
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
        title: Text("WATER QUALITY"),
        bottom: TabBar(
            controller: _tabController,
            onTap: (int index) {
              setState(() {
                tabIndex = index;
              });
            },
            tabs: [
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
            ]),
      ),
      body: StreamBuilder(
          stream: firebaseData.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              print("${snapshot.data.snapshot.value.toString()}");
             
              var _show = SAL.fromJson(snapshot.data.snapshot.value);
              print("SAL : ${_show.temp} / ${_show.ec} / ${_show.sal}");
              if(_show.sal > 30){
                sendNotification(title: 'Caution!',detail: 'Salinity Too Much! ${_show.sal.floor()} ppt');
              }
              return IndexedStack(
                  index: tabIndex,
                  children: [_tempLayout(_show), _salLayout(_show)]);
            } else {
              return Center(child: Text("No Data"));
            }
          }),
    );
  }

  Widget _tempLayout(SAL _show) {
    return Center(
        child: Column(
      children: [
  
        Container(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            "TEMPERATURE",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: FAProgressBar(
            progressColor: Colors.green,
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.up,
            size: 100,
            currentValue: _show.temp.round(),
            changeColorValue: 50,
            changeProgressColor: Colors.red,
            maxValue: 50,
            displayText: "°C",
            borderRadius: BorderRadius.circular(16),
            animatedDuration: Duration(milliseconds: 500),
          ),
        )),
        Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              "${_show.temp.toStringAsFixed(2)} °C",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ))
      ],
    ));
  }

  Widget _salLayout(SAL _show) {
    return Center(
        child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            "SALINITY",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: FAProgressBar(
            progressColor: Colors.orange[200],
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.up,
            size: 100,
            currentValue: _show.sal.round(),
            changeColorValue: 50,
            changeProgressColor: Colors.red[200],
            maxValue: 42,
            displayText: " ppt",
            borderRadius: BorderRadius.circular(16),
            animatedDuration: Duration(milliseconds: 500),
          ),
        )),
        Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              "${_show.sal.toStringAsFixed(2)} ppt",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ))
      ],
    ));
  }
}
