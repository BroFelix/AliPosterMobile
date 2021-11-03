import 'dart:convert';

import 'package:ali_poster/data/model/worker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveUser(Map user) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("user", json.encode(user));
}

Future<Worker> getUser() async {
  var prefs = await SharedPreferences.getInstance();
  return Worker.fromJson(json.decode(prefs.getString("user")!));
}

void logOut() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<bool> isLoggedIn() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.get("user") != null) {
    return true;
  } else {
    return false;
  }
}

Future<String?> getFCMToken() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString("fcmtoken");
}

Future<void> setFCMToken(String token) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("fcmtoken", token);
}
