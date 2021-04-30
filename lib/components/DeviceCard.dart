import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  final Widget item;
  final String postFix;
  final value;
  DeviceCard({Key key, this.item, this.value, this.postFix}) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    if (widget.postFix.toUpperCase() == "C") {
      if (widget.value < 30) {
        setState(() {
          color = Colors.blue;
        });
      } else {
        color = Colors.red;
      }
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.item,
            Text(
              '${widget.value.floor()} ${widget.postFix} ',
              style: TextStyle(fontSize: 24, color: color),
            )
          ],
        ),
      ),
    );
  }
}
