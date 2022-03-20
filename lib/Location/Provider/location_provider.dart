import 'package:flutter/material.dart';
import '../../Utility/constants.dart';
class LocationProvider with ChangeNotifier {
  String? val = countries[0]['val'];
  String? currentCountry=countries[0]['location'];

  void setVal(String newVal){
    val = newVal;
    notifyListeners();
  }
  void setCountry(String newCountry){
    currentCountry = newCountry;
    notifyListeners();
  }
}