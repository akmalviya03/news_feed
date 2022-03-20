import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
   bool connected = true;
   bool prevConnected =false;
  void setConnectivity(bool newConnectedResult){
    connected = newConnectedResult;
    notifyListeners();
  }

   void setPrevConnectivity(bool newPrevConnectedResult){
     prevConnected = newPrevConnectedResult;
     notifyListeners();
   }


}