import 'package:flutter/cupertino.dart';
import 'package:news_feed/newsModels/articles_model.dart';

class NewsProvider with ChangeNotifier{

  late List<Articles>? _articles;
  List<Articles>? get articles => _articles;

  void initializeArticlesList(List<Articles>? _articlesFromHome){
    _articles = [];
    _articles = _articlesFromHome;
    notifyListeners();
  }




}