import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider extends ChangeNotifier {
  String? _city;

  String? get city => _city;

  LocationProvider() {
    _loadLocation();
  }

  void _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('user_city');
    notifyListeners();
  }

  Future<void> setLocation(String city) async {
    _city = city;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_city', city);
    notifyListeners();
  }

  Future<void> clearLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_city');
    _city = null;
    notifyListeners();
  }
}
