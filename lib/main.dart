import 'package:firebasetest/showDB.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'showDB.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShowDB(),
    );
  }
}

void readData(){
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference databaseReference = firebaseDatabase.reference().child('DHT/Json');

  databaseReference.once().then((DataSnapshot dataSnapshot){
    print(dataSnapshot.value);
  });
}