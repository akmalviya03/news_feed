import 'package:flutter/material.dart';

class RetryProvider with ChangeNotifier {
   bool retryPagination = false;

   bool retryHomePage = false;

   void resetRetryHomePage(){
     retryHomePage = false;
     // notifyListeners();
   }
   void changeRetryHome(){
     retryHomePage =true;
     notifyListeners();
   }

  void resetRetryPagination(){
    retryPagination = false;
    notifyListeners();
  }

  void changeRetryPagination(){
    retryPagination =true;
    notifyListeners();
  }

}