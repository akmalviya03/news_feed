import 'package:flutter/cupertino.dart';
import 'package:news_feed/News/newsModels/articles_model.dart';

class SearchProvider with ChangeNotifier {

  late List<Articles> _searchedArticles=[];
  List<Articles> get getSearchedArticles => _searchedArticles;

  void fillSearchedArticles(List<Articles> filteredList){
    _searchedArticles = filteredList;
    notifyListeners();
  }

}
