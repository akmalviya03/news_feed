import 'package:flutter/material.dart';

class RetryProvider with ChangeNotifier {
   bool retryPagination = false;
  void resetRetryPagination(){
    retryPagination = false;
    notifyListeners();
  }

  void changeRetryPagination(){
    retryPagination =true;
    notifyListeners();
  }

}