import 'package:flutter/cupertino.dart';
import 'package:news_feed/Models/articles_model.dart';

class NewsProvider with ChangeNotifier {
  late int? _totalArticles;
  late int _currentPage=1;
  late List<Articles>? _articles=[];
  late int _totalArticlesInList=0;
  late bool _fetchMore = false;

  int? get totalArticles => _totalArticles;
  int get currentPage => _currentPage;
  int get totalArticlesInList => _totalArticlesInList;
  List<Articles>? get articles => _articles;
  bool get fetchingMore => _fetchMore;

  void initializeArticlesList(List<Articles>? _articlesFromHome) {
    resetCurrentPage();
    _articles = [];
    _articles = _articlesFromHome;
    _totalArticlesInList= _articles!.length;
    _currentPage = 2;
    notifyListeners();
  }

  void incrementCurrentPage(){
    _currentPage++;
  }

  void resetCurrentPage(){
    _currentPage =1;
  }

  void addMoreArticlesToList(List<Articles>? _moreArticles) {
    _moreArticles?.forEach((element) {
      _articles?.add(element);
    });
    _totalArticlesInList= _articles!.length;
    incrementCurrentPage();
    notifyListeners();
  }

  void setTotalArticles(int? value) {
    _totalArticles = value;
    notifyListeners();
  }

  void fetching(){
    _fetchMore = true;
    notifyListeners();
  }
  void fetchingDone(){
    _fetchMore = false;
    notifyListeners();
  }
}
