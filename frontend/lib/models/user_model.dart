/*import 'package:flutter/material.dart';

class user_model with ChangeNotifier {
   late String _username='';
  //late String _role='';
  String get username => _username;
  //String get role=>_role; 
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
  /*void setRole(String role) {
    _role = role;
    notifyListeners();
  }*/
}*/
import 'package:flutter/material.dart';

class user_model with ChangeNotifier {
  late String _username = '';
  late String _fcmToken = ''; // New field for FCM token

  String get username => _username;
  String get fcmToken => _fcmToken; // Getter for FCM token

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setFcmToken(String token) {
    _fcmToken = token;
    notifyListeners();
  }
}

