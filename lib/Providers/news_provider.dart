import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_feed/Models/articles_model.dart';
import 'package:news_feed/Providers/retry_provider.dart';
import 'package:provider/provider.dart';
import '../Components/bottom_sheet_methods.dart';
import '../Components/select_category_bottomsheet_ui.dart';
import '../Components/select_location_bottomsheet_ui.dart';
import '../Constants/constants.dart';
import '../Models/news_list_model.dart';
import '../Services/news_api.dart';
import 'category_provider.dart';
import 'location_provider.dart';

class NewsProvider with ChangeNotifier {
  late int? _totalArticles;
  int _currentPage = 1;
  List<Articles>? _articles = [];
  int _totalArticlesInList = 0;
  bool _fetchingMore = false;

  List<Articles>? get articles => _articles;
  bool get fetchingMore => _fetchingMore;

  late LocationProvider _locationProvider;
  late CategoryProvider _categoryProvider;
  late RetryProvider _retryProvider;

  late ScrollController _controller;
  ScrollController get controller => _controller;

  final NewsApi _newsApi = NewsApi();
  late NewsListModel _newsListModel;
  final BottomSheetMethods _bottomSheetMethods = BottomSheetMethods();
  final SelectLocationBottomSheetUI _selectLocationBottomSheetUI =
      SelectLocationBottomSheetUI();
  final SelectCategoryBottomSheetUI _selectCategoryBottomSheetUI =
      SelectCategoryBottomSheetUI();

  late BuildContext _context;
  late Future future;
  bool internetWorking = true;
  final Connectivity _connectivity = Connectivity();

  NewsProvider();

  initializeValues(BuildContext context) {
    _context = context;
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _retryProvider = Provider.of<RetryProvider>(context, listen: false);
    _controller = ScrollController()..addListener(_scrollListener);
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    future = getNews();
  }

  void initializeArticlesList(List<Articles>? _articlesFromHome) {
    resetCurrentPage();
    _articles = [];
    _articles = _articlesFromHome;
    _totalArticlesInList = _articles!.length;
    incrementCurrentPage();
    notifyListeners();
  }

  void setTotalArticles(int? value) {
    _totalArticles = value;
    notifyListeners();
  }

  Future<void> scrollToTop() {
    return _controller.animateTo(_controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void _scrollListener() {
    if (_controller.position.extentAfter == 0) {
      loadMoreNews();
    }
  }

  Future getNews() async {
    _retryProvider.resetRetryHomePage();
    await _newsApi
        .getCountryNews(
            countryName: _locationProvider.val!,
            categoryName: _categoryProvider.selectedCategory)
        .then((value) {
      if (value.runtimeType == NewsListModel) {
        _newsListModel = value;
        initializeArticlesList(_newsListModel.articles);
        setTotalArticles(_newsListModel.totalResults);
      }
      return value;
    }, onError: (error) {
      if (kDebugMode) {
        print(error.toString() + "Some GetNews");
      }
      _retryProvider.changeRetryHome();
      return error;
    });
    scrollToTop();
  }

  Future loadMoreNews() async {
    if (((_totalArticles)! > (_totalArticlesInList)) &&
        _fetchingMore == false) {
      fetching();
      _retryProvider.resetRetryPagination();
      await _newsApi
          .getCountryNews(
              page: _currentPage,
              categoryName: _categoryProvider.selectedCategory,
              countryName: _locationProvider.val!)
          .then((value) {
        if (value.runtimeType == NewsListModel) {
          _newsListModel = value;
          addMoreArticlesToList(_newsListModel.articles);
          fetchingDone();
        }

        return value;
      }, onError: (error) {
        if (kDebugMode) {
          print(error.toString() + "Some LoadMoreNews");
        }
        fetchingDone();
        _retryProvider.changeRetryPagination();
        return error;
      });
    }
    return Future.value('We are having some issues while fetching data');
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    return _updateConnectionStatus(result);
  }

  void showSnackBar() {
    internetWorking = false;
    ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
      content: const Text('No Internet Connection'),
      duration: const Duration(days: 1),
      action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(_context).hideCurrentSnackBar();
          }),
    ));
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('example.com');
        bool res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        if (res) {
          internetWorking = true;
          ScaffoldMessenger.of(_context).clearSnackBars();
        }
      } on SocketException catch (_) {
        showSnackBar();
      }
    } else {
      ScaffoldMessenger.of(_context).clearSnackBars();
      showSnackBar();
    }
  }

  void incrementCurrentPage() {
    _currentPage++;
  }

  void resetCurrentPage() {
    _currentPage = 1;
  }

  void addMoreArticlesToList(List<Articles>? _moreArticles) {
    _moreArticles?.forEach((element) {
      _articles?.add(element);
    });
    _totalArticlesInList = _articles!.length;
    incrementCurrentPage();
    notifyListeners();
  }

  void fetching() {
    _fetchingMore = true;
    notifyListeners();
  }

  void fetchingDone() {
    _fetchingMore = false;
    notifyListeners();
  }

  Future showSelectLocationBottomSheet() {
    return _bottomSheetMethods.showCustomBottomSheet(
        context: _context,
        childList: _selectLocationBottomSheetUI.showSelectLocationBottomSheet(),
        heading: 'Choose your Location',
        applyFilter: () {
          Navigator.pop(_context);
          _locationProvider.setCountry(countries[countries.indexWhere(
                  (element) => element['val'] == _locationProvider.val!)]
          ['location']!);
          _categoryProvider.resetSelectedCategory();
          future = getNews();
        });
  }

  Future showSelectCategoryBottomSheet() {
    return _bottomSheetMethods.showCustomBottomSheet(
      heading: 'Filter by categories',
      applyFilter: () {
        Navigator.pop(_context);
        future = getNews();
      },
      context: _context,
      childList: _selectCategoryBottomSheetUI.showSelectCategoryBottomSheet(),
    );
  }
}
