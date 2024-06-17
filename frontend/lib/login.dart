
/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens_and_main/componant/sidebar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class login_screen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String loggedInUsername;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _login(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:2000/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );
    

      if (response.statusCode == 200) {
        Provider.of<user_model>(context, listen: false).setUsername(usernameController.text);
Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sider_page()),
        );
      print('Login response: ${response.statusCode}');
    print('Login response body: ${response.body}'); }
       /* // Get the FCM token
        String? fcmToken = await _firebaseMessaging.getToken();
        print('FCM token: $fcmToken');

        if (fcmToken != null) {
          // Send the FCM token to your backend
          final tokenResponse = await http.post(
            Uri.parse('http://localhost:2000/api/users/update-fcm-token'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': usernameController.text,
              'fcmToken': fcmToken,
            }),
          );

          print('Token update response: ${tokenResponse.statusCode}');
          print('Token update response body: ${tokenResponse.body}');

          if (tokenResponse.statusCode != 200) {
            throw Exception('Failed to update FCM token');
          }
        }

        setState(() {
          loggedInUsername = usernameController.text;
        });

        // Navigate to the other page if credentials are correct
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sider_page()),
        );
      } else {
        _showErrorDialog('Invalid username or password');
      }*/
    } catch (error) {
      print('Login error: $error');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("aptiv_background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Card(
              color: Colors.black,
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('image/APTIV_logo.PNG'),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(246, 255, 51, 0),
                      ),
                      onPressed: () {
                        _login(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens_and_main/componant/sidebar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class login_screen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String loggedInUsername;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> _login(BuildContext context) async {
      await _firebaseMessaging.requestPermission();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:2000/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Provider.of<user_model>(context, listen: false)
            .setUsername(usernameController.text);

        // Get the FCM token
        /*String?*/ final fcmToken = await _firebaseMessaging.getToken();
        print('FCM token: $fcmToken');

        if (fcmToken != null) {
          // Send the FCM token to your backend
          final tokenResponse = await http.post(
            Uri.parse('http://localhost:2000/api/users/update-fcm-token'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': usernameController.text,
              'fcmToken': fcmToken,
            }),
          );

          print('Token update response: ${tokenResponse.statusCode}');
          print('Token update response body: ${tokenResponse.body}');

          if (tokenResponse.statusCode != 200) {
            throw Exception('Failed to update FCM token');
          }
        }

        setState(() {
          loggedInUsername = usernameController.text;
        });

        // Navigate to the other page if
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sider_page()),
        );
      } else {
        _showErrorDialog('Invalid username or password');
      }
    } catch (error) {
      print('Login error: $error');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("aptiv_background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Card(
              color: Colors.black,
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('image/APTIV_logo.PNG'),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(246, 255, 51, 0),
                      ),
                      onPressed: () {
                        _login(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';

import 'package:frontend/screens_and_main/componant/sidebar.dart';

class login_screen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String loggedInUsername;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
     messaging.requestPermission();
    messaging.getToken().then((token) {
      print("FCM Token: $token");
      // Optionally, save the token to the backend or use it as needed
    });
  }

  Future<void> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Provider.of<user_model>(context, listen: false).setUsername(usernameController.text);
      // Provider.of<user_model>(context, listen: false).setRole(responseData['role']);
    messaging.getToken().then((token) {
      print("FCM Token: $token");
      // Optionally, save the token to the backend or use it as needed
    });
      setState(() {
        loggedInUsername = usernameController.text;
      });

      // Navigate to the other page if credentials are correct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => sider_page()),
      );
    } else {
      // Show an error message if credentials are incorrect
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/aptiv_background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 300, // Adjust the width of the card
            height: 300, // Adjust the height of the card
            child: Card(
              color: Colors.black,
              elevation: 10, // Adjust the elevation of the card
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('image/APTIV_logo.PNG'),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true, // Hide password
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(246, 255, 51, 0), // Orange button color
                      ),
                      onPressed: () {
                        _login(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontWeight: FontWeight.bold, // Set text to bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens_and_main/componant/sidebar.dart';

class login_screen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String loggedInUsername;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    messaging.getToken().then((token) {
      print("FCM Token: $token");
      Provider.of<user_model>(context, listen: false).setFcmToken(token!); // Set FCM token in user model
      // Optionally, save the token to the backend or use it as needed
    });
  }

  Future<void> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
        'fcmToken': Provider.of<user_model>(context, listen: false).fcmToken, // Include the FCM token from user model
      }),
    );

    if (response.statusCode == 200) {
      Provider.of<user_model>(context, listen: false).setUsername(usernameController.text);

      setState(() {
        loggedInUsername = usernameController.text;
      });

      // Navigate to the other page if credentials are correct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => sider_page()),
      );
    } else {
      // Show an error message if credentials are incorrect
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/aptiv_background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Card(
              color: Colors.black,
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('image/APTIV_logo.PNG'),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(246, 255, 51, 0),
                      ),
                      onPressed: () {
                        _login(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/screens_and_main/componant/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';


class login_screen extends StatefulWidget {
 @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<login_screen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String loggedInUsername;


  Future<void> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
            //final Map<String, dynamic> responseData = json.decode(response.body);

            Provider.of<user_model>(context, listen: false).setUsername(usernameController.text);
                //  Provider.of<user_model>(context, listen: false).setRole(responseData['role']);

      setState(() {
        loggedInUsername = usernameController.text;
      });
      // Navigate to the other page if credentials are correct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => sider_page()),
      );
    } else {
      // Show an error message if credentials are incorrect
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Ensure keyboard doesn't overflow content
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Take the full height of the screen
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/aptiv_background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 300, // Adjust the width of the card
                height: 400, // Adjust the height of the card
                child: Card(
                  color: Colors.black,
                  elevation: 10, // Adjust the elevation of the card
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('image/APTIV_logo.PNG', height: 100), // Adjust logo size
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            filled: true,
                            fillColor: Colors.grey,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true, // Hide password
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.grey,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(246, 255, 51, 0), // Orange button color
                            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                          ),
                          onPressed: () {
                            _login(context);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white, // Set text color to white
                              fontWeight: FontWeight.bold, // Set text to bold
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0), // Adjust spacing as needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

