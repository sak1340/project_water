import 'package:firebase_core/firebase_core.dart';
import 'package:firebasetest/showDB.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'showDB.dart';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: ShowDB(),
  //   );
  // }
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('CANNOT CONECT TO FIREBASE'),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: ShowDB()
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ) 
    );
  }
}

// void readData(){
//   FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
//   DatabaseReference databaseReference = firebaseDatabase.reference().child('DHT/Json');

//   databaseReference.once().then((DataSnapshot dataSnapshot){
//     print(dataSnapshot.value);
//   });
// }
