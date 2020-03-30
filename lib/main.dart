import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fallaid Notifications'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String textValue = 'Hello World!';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  Firestore _db = new Firestore();

  @override
  void initState() {
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg){
        print("onLaunch called");
      },
      onResume: (Map<String, dynamic> msg){
        print("onResume called");
      },
      onMessage: (Map<String, dynamic> msg){
        print("onMessage called");
      }
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings){
      print('IOS Setting Registered');
    });
    firebaseMessaging.getToken().then((token){
      update(token);
    });
    //firebaseMessaging.subscribeToTopic('falls');
  }

  update(String fcmToken) async {
    textValue = fcmToken;
    /// Get the token, save it to the database for current user
    // Get the current user
    String uid = 'test_user_1';
    // FirebaseUser user = await _auth.currentUser();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
      });
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              textValue,
            ),
          ],
        ),
      ),
    );
  }
}
