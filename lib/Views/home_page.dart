import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Providers/category_provider.dart';
import 'package:news_feed/Views/search_page.dart';
import 'package:news_feed/Components/bottom_sheet_methods.dart';
import 'package:news_feed/Components/text_field_search.dart';
import 'package:provider/provider.dart';
import '../Components/select_category_bottomsheet_ui.dart';
import '../Components/select_location_bottomsheet_ui.dart';
import '../Components/center_text.dart';
import '../Constants/constants.dart';
import '../Providers/location_provider.dart';
import '../Components/location_button.dart';
import '../Services/news_api.dart';
import '../Models/news_list_model.dart';
import '../Providers/newsProvider.dart';
import '../Components/news_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsApi _newsApi = NewsApi();
  late Future _future;
  late ScrollController _controller;
  late NewsListModel newsListModel;
  bool internetWorking = true;
  late final LocationProvider _locationProvider;
  late final NewsProvider _newsProvider;
  late final CategoryProvider _categoryProvider;
  late final RetryProvider _retryProvider;
  final BottomSheetMethods _bottomSheetMethods = BottomSheetMethods();
  final SelectLocationBottomSheetUI _selectLocationBottomSheetUI =
      SelectLocationBottomSheetUI();
  final SelectCategoryBottomSheetUI _selectCategoryBottomSheetUI =
      SelectCategoryBottomSheetUI();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future getNews() async {
    await _newsApi
        .getCountryNews(
            countryName: _locationProvider.val!,
            categoryName: _categoryProvider.selectedCategory)
        .then((value) {
      newsListModel = value as NewsListModel;
      _newsProvider.initializeArticlesList(newsListModel.articles);
      _newsProvider.setTotalArticles(newsListModel.totalResults);
      return value;
    }, onError: (error) {
      return error;
    });
    scrollToTop();
  }

  Future<void> scrollToTop() {
    return _controller.animateTo(_controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Future loadMoreNews() async {
    if (((_newsProvider.totalArticles)! >
            (_newsProvider.totalArticlesInList)) &&
        _newsProvider.fetchingMore == false) {
      _newsProvider.fetching();
      _retryProvider.resetRetryPagination();
      await _newsApi
          .getCountryNews(
              page: _newsProvider.currentPage,
              categoryName: _categoryProvider.selectedCategory,
              countryName: _locationProvider.val!)
          .then((value) {
        newsListModel = value as NewsListModel;
        _newsProvider.addMoreArticlesToList(newsListModel.articles);
        _newsProvider.fetchingDone();
        return Future.value(value);
      }, onError: (error) {
        _newsProvider.fetchingDone();
        _retryProvider.changeRetryPagination();
        return Future.error(error);
      });
    }
    return Future.value('We are having some issues while fetching data');
  }

  void _scrollListener() {
    if (_controller.position.extentAfter == 0) {
      loadMoreNews();
    }
  }

  @override
  void initState() {
    super.initState();
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _newsProvider = Provider.of<NewsProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _retryProvider =
        Provider.of<RetryProvider>(context, listen: false);
    _controller = ScrollController()..addListener(_scrollListener);
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _future = getNews();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _controller.dispose();
    _newsProvider.dispose();
    _categoryProvider.dispose();
    _locationProvider.dispose();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  void showScaffold() {
    internetWorking = false;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('No Internet Connection'),
      duration: const Duration(days: 1),
      action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      } on SocketException catch (_) {
        showScaffold();
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      showScaffold();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'MyNEWS',
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                _bottomSheetMethods.showCustomBottomSheet(
                    context: context,
                    childList: _selectLocationBottomSheetUI
                        .showSelectLocationBottomSheet(),
                    heading: 'Choose your Location',
                    applyFilter: () {
                      Navigator.pop(context);
                      _locationProvider.setCountry(countries[
                              countries.indexWhere((element) =>
                                  element['val'] == _locationProvider.val!)]
                          ['location']!);
                      _categoryProvider.resetSelectedCategory();
                      _future = getNews();
                    });
              },
              child: const LocationButton(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            _bottomSheetMethods.showCustomBottomSheet(
              heading: 'Filter by categories',
              applyFilter: () {
                Navigator.pop(context);
                _future = getNews();
              },
              context: context,
              childList:
                  _selectCategoryBottomSheetUI.showSelectCategoryBottomSheet(),
            );
          },
          child: const Icon(Icons.filter_alt_outlined),
        ),
        body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print('Hello');
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SearchPage()));
                  },
                  child: Hero(
                      tag: 'Search',
                      child: TextFieldSearch(
                        enabled: false,
                        callback: (string) {},
                      ))),

              //Top Headlines
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04,
                      bottom: MediaQuery.of(context).size.width * 0.04),
                  child: Text(
                    'Top Headlines',
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Consumer<NewsProvider>(
                          builder: (context, newsProvider, child) {
                            return Column(
                              children: [
                                Expanded(
                                  child: newsProvider.articles!.isNotEmpty
                                      ? NewsList(
                                          controller: _controller,
                                        )
                                      : const CenterText(
                                          text: 'OOPS! We ran out of articles',
                                        ),
                                ),
                                Consumer<RetryProvider>(builder:
                                    (context, retryProvider, child) {
                                  if (retryProvider.retryPagination ==
                                      false) {
                                    return Visibility(
                                      visible: newsProvider.fetchingMore,
                                      child: const CircularProgressIndicator(),
                                    );
                                  } else {
                                    return TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .primaryColor)),
                                        onPressed: () {
                                          if (internetWorking == true) {
                                            _future = loadMoreNews();
                                          }
                                        },
                                        child: Text(
                                          'Load More Articles',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white),
                                        ));
                                  }
                                })
                              ],
                            );
                          },
                        );
                      } else {
                        return CenterText(text: snapshot.error.toString());
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
