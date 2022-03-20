import 'package:flutter/material.dart';

import '../../Utility/constants.dart';
class CategoryProvider with ChangeNotifier {
  String selectedCategory='';

  void setCategory(String newCategory){
    selectedCategory = newCategory;
    notifyListeners();
  }
  void resetSelectedCategory(){
    for (var element in categories) {
      if(element['value'] == true){
        element['value'] = false;
      }
    }
    selectedCategory = '';
    notifyListeners();
  }
}