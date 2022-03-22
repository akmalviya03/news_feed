import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
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