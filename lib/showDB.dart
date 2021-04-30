import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'sal.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ShowDB extends StatefulWidget {
  @override
  _ShowDBState createState() => _ShowDBState();
}

class _ShowDBState extends State<ShowDB> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int tabIndex = 0;

  DatabaseReference firebaseData =
      FirebaseDatabase.instance.reference().child('DHT/Json');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            borderRadius: 16,
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
            borderRadius: 16,
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
