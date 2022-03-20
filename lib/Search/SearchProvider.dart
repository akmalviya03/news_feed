import 'package:flutter/cupertino.dart';
import 'package:news_feed/News/newsModels/articles_model.dart';

class SearchProvider with ChangeNotifier {

  late List<Articles> _searched_articles=[];
  List<Articles> get get_searched_articles => _searched_articles;

  void fillSearchedArticles(List<Articles> filteredList){
    _searched_articles = filteredList;
    notifyListeners();
  }

}
