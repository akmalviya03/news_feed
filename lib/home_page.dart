import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_feed/Category/Provider/category_provider.dart';
import 'package:news_feed/Search/search_page.dart';
import 'package:news_feed/customBottomSheet/bottom_sheet_methods.dart';
import 'package:news_feed/Shared/textFieldSearch.dart';
import 'package:provider/provider.dart';
import 'Category/UI/select_category_bottomsheet_ui.dart';
import 'Location/UI/select_location_bottomsheet_ui.dart';
import 'connectivity_provider.dart';
import 'constants.dart';
import 'Location/Provider/location_provider.dart';
import 'networkApis/news_api.dart';
import 'News/newsModels/news_list_model.dart';
import 'News/Provider/newsProvider.dart';
import 'News/UI/news_list.dart';
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

  late final LocationProvider locationProvider;
  late final ConnectivityProvider _connectivityProvider;
  late final NewsProvider newsProvider;
  late final CategoryProvider _categoryProvider;

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
            countryName: locationProvider.val!,
            categoryName: _categoryProvider.selectedCategory)
        .then((value) {
      newsListModel = value as NewsListModel;
      newsProvider.initializeArticlesList(newsListModel.articles);
      newsProvider.setTotalArticles(newsListModel.totalResults);
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
    if (((newsProvider.totalArticles)! > (newsProvider.totalArticlesInList)) &&
        newsProvider.fetchMore != true) {
      newsProvider.fetching();
      await _newsApi
          .getCountryNews(
              page: newsProvider.currentPage,
              categoryName: _categoryProvider.selectedCategory,
              countryName: locationProvider.val!)
          .then((value) {
        newsListModel = value as NewsListModel;
        newsProvider.addMoreArticlesToList(newsListModel.articles);
        newsProvider.fetchingDone();
        return value;
      }, onError: (error) {
        return error;
      });
    }
    return Future.value('We are having some issues while fetching data');
  }

  void _scrollListener() {
    if (_controller.position.extentAfter == 0 &&
        newsProvider.fetchMore != true) {
      loadMoreNews();
    }
  }

  @override
  void initState() {
    super.initState();
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
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
    newsProvider.dispose();
    _categoryProvider.dispose();
    locationProvider.dispose();
    _connectivityProvider.dispose();
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool prevConnectedValue = _connectivityProvider.connected;
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('example.com');
        var res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        _connectivityProvider.setPrevConnectivity(prevConnectedValue);
        _connectivityProvider.setConnectivity(res);
      } on SocketException catch (_) {
        setState(() {
          _connectivityProvider.setPrevConnectivity(prevConnectedValue);
          _connectivityProvider.setConnectivity(false);
        });
      }
    } else {
      _connectivityProvider.setPrevConnectivity(prevConnectedValue);
      _connectivityProvider.setConnectivity(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'MyNEWS',
          style: TextStyle(color: Colors.white, fontSize: 16),
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
                    locationProvider.setCountry(countries[countries.indexWhere(
                            (element) =>
                                element['val'] == locationProvider.val!)]
                        ['location']!);
                    _categoryProvider.resetSelectedCategory();
                    _future = getNews();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                    return Text(
                      locationProvider.currentCountry!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    );
                  })
                ],
              ),
            ),
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
      body: Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, child) {
          if (connectivityProvider.connected == true) {
            return SafeArea(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Text(
                        'Top Headlines',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                Expanded(
                                  child: newsProvider.articles!.isNotEmpty
                                      ? NewsList(
                                          controller: _controller,
                                        )
                                      : connectivityProvider.prevConnected ==
                                              false
                                          ? Center(
                                              child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                      'No Internet Connection'),
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Theme.of(
                                                                          context)
                                                                      .primaryColor)),
                                                      onPressed: () {
                                                        setState(() {
                                                          _future = getNews();
                                                        });
                                                      },
                                                      child:
                                                          const Text('Retry'))
                                                ],
                                              ),
                                            ))
                                          : const Center(
                                              child: Text(
                                                  'OOPS! We ran out of articles')),
                                ),
                                Consumer<NewsProvider>(
                                  builder: (context, newsProvider, child) {
                                    return Visibility(
                                        visible: newsProvider.fetchMore,
                                        child:
                                            const CircularProgressIndicator());
                                  },
                                )
                              ],
                            );
                          } else {
                            return Text(snapshot.error.toString());
                          }
                        }),
                  )
                ],
              ),
            );
          } else {
            return const Center(
                child: Text('OOPS! You are not connected to the internet'));
          }
        },
      ),
    );
  }
}
