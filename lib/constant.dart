import 'package:shared_preferences/shared_preferences.dart';

Future<void> setFirst() async {
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  prefs.setBool("First", true);
}

Future<void> getFirst() async {
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  return  prefs.getBool("First");
}