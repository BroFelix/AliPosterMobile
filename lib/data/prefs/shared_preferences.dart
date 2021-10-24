import 'package:shared_preferences/shared_preferences.dart';

void save(String code) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("user", code);
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
