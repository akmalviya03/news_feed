import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Category/Provider/category_provider.dart';
import 'package:news_feed/Search/search_page.dart';
import 'package:news_feed/customBottomSheet/bottom_sheet_methods.dart';
import 'package:news_feed/Shared/text_field_search.dart';
import 'package:provider/provider.dart';
import '../Category/UI/select_category_bottomsheet_ui.dart';
import '../Location/UI/select_location_bottomsheet_ui.dart';
import '../center_text.dart';
import '../networkApis/connectivity_provider.dart';
import '../Utility/constants.dart';
import '../Location/Provider/location_provider.dart';
import 'location_button.dart';
import '../networkApis/news_api.dart';
import '../News/newsModels/news_list_model.dart';
import '../News/Provider/newsProvider.dart';
import '../News/UI/news_list.dart';
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

  late final LocationProvider _locationProvider;
  late final ConnectivityProvider _connectivityProvider;
  late final NewsProvider _newsProvider;
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
        _newsProvider.fetchMore != true) {
      _newsProvider.fetching();
      await _newsApi
          .getCountryNews(
              page: _newsProvider.currentPage,
              categoryName: _categoryProvider.selectedCategory,
              countryName: _locationProvider.val!)
          .then((value) {
        newsListModel = value as NewsListModel;
        _newsProvider.addMoreArticlesToList(newsListModel.articles);
        _newsProvider.fetchingDone();
        return value;
      }, onError: (error) {
        return error;
      });
    }
    return Future.value('We are having some issues while fetching data');
  }

  void _scrollListener() {
    if (_controller.position.extentAfter == 0 &&
        _newsProvider.fetchMore != true) {
      loadMoreNews();
    }
  }

  @override
  void initState() {
    super.initState();
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _newsProvider = Provider.of<NewsProvider>(context, listen: false);
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
    _newsProvider.dispose();
    _categoryProvider.dispose();
    _locationProvider.dispose();
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
                    _locationProvider.setCountry(countries[countries.indexWhere(
                            (element) =>
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                Expanded(
                                  child: _newsProvider.articles!.isNotEmpty
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
                                                  Text(
                                                    'No Internet Connection',
                                                    style: GoogleFonts
                                                        .montserrat(),
                                                  ),
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
                                                      child: Text(
                                                        'Retry',
                                                        style: GoogleFonts
                                                            .montserrat(),
                                                      ))
                                                ],
                                              ),
                                            ))
                                          : const CenterText(
                                              text:
                                                  'OOPS! We ran out of articles',
                                            ),
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
                            return CenterText(text: snapshot.error.toString());
                          }
                        }),
                  )
                ],
              ),
            );
          } else {
            return const CenterText(
                text: 'OOPS! You are not connected to the internet');
          }
        },
      ),
    );
  }
}
