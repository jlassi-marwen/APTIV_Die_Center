/*import 'package:flutter/material.dart';
import 'package:frontend/login.dart';
import 'package:frontend/screens_and_main/dashboard.dart';
import 'package:frontend/screens_and_main/fetch.dart';
import 'package:frontend/screens_and_main/scan.dart';
import 'package:frontend/screens_and_main/history.dart';


void main()=>runApp(MaterialApp(
 debugShowCheckedModeBanner: false,

  home:login_screen()
));*/


/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:frontend/screens_and_main/componant/sidebar.dart'; // This should be your app bar file

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => user_model(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,

      home: login_screen(),
    );
  }
}*/

/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/login.dart';
import 'package:frontend/screens_and_main/componant/sidebar.dart'; // This should be your app bar file
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'key',
    appId: 'id',
    messagingSenderId: 'sendid',
    projectId: 'myapp',
    storageBucket: 'myapp-b9yt18.appspot.com',
  ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => user_model(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:login_screen(),
    );
  }
}*/

/*
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;

    // Get the token each time the application loads
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("Firebase Messaging Token: $token");
      // Save the token to your server or database if necessary
    });

    // Configure message handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      // Handle your message and display a notification
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Handle your message and navigate to a different screen if necessary
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Firebase Messaging Example'),
      ),
    );
  }
}
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens_and_main/dashboard.dart';
import 'package:frontend/screens_and_main/stats.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/login.dart';
import 'package:frontend/screens_and_main/componant/sidebar.dart'; // This should be your app bar file
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyC4s00lMlwWken9B5-tDr7vq3y1m34hwVw',
    appId: '1:399376595463:android:eece5bb4fddd02046908a2',
    messagingSenderId: '399376595463',
    projectId: 'notifications-3b64f',
    storageBucket: 'notifications-3b64f.appspot.com',
  ));*/
  runApp(
    
    ChangeNotifierProvider(
      create: (context) => user_model(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login_screen(),
      
    );
  }
}


