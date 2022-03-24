import 'package:flutter/cupertino.dart';
import 'package:news_feed/Models/articles_model.dart';

class SearchProvider with ChangeNotifier {
  List<Articles> _searchedArticles=[];
  bool _openedFirstTime = true;
  List<Articles> get getSearchedArticles => _searchedArticles;

  bool get openedFirstTime => _openedFirstTime;

  void fillSearchedArticles(List<Articles> filteredList){
    _searchedArticles = filteredList;
    notifyListeners();
  }

  void setOpenedFirstTimeToFalse(){
    _openedFirstTime = false;
    notifyListeners();
  }

}
