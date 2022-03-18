import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/customBottomSheet/bottom_sheet_methods.dart';
import 'package:news_feed/textFieldSearch.dart';
import 'package:provider/provider.dart';
import 'customBottomSheet/select_category_bottomsheet_ui.dart';
import 'customBottomSheet/select_location_bottomsheet_ui.dart';
import 'constants.dart';
import 'customBottomSheet/custom_bottom_sheet_ui.dart';
import 'Location/Provider/location_provider.dart';
import 'networkApis/news_api.dart';
import 'News/newsModels/news_list_model.dart';
import 'News/Provider/newsProvider.dart';
import 'News/UI/news_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsApi _newsApi = NewsApi();
  // String dropdownValue = 'Newest';
  late Future _future;
  late ScrollController _controller;
  late NewsListModel newsListModel;

  late final locationProvider;
  late final newsProvider;

  final BottomSheetMethods _bottomSheetMethods = BottomSheetMethods();
  final SelectLocationBottomSheetUI _selectLocationBottomSheetUI = SelectLocationBottomSheetUI();
  final SelectCategoryBottomSheetUI _selectCategoryBottomSheetUI = SelectCategoryBottomSheetUI();

  Future getNews({String countryName = 'in'}) async {
    newsListModel = await _newsApi.getCountryNews(countryName: countryName);
    newsProvider.initializeArticlesList(newsListModel.articles);
    newsProvider.setTotalArticles(newsListModel.totalResults);
    return 'Done';
  }

  Future loadMoreNews({String countryName = 'in'}) async {
    if (((newsProvider.totalArticles)! > (newsProvider.totalArticlesInList)) &&
        newsProvider.fetchMore != true) {
      newsProvider.fetching();
      newsListModel =
          await _newsApi.getCountryNews(page: newsProvider.currentPage);
      newsProvider.addMoreArticlesToList(newsListModel.articles);
      newsProvider.fetchingDone();
    }
    return 'Done';
  }

  void _scrollListener() {
    if (_controller.position.extentAfter == 0 &&
        newsProvider.fetchMore != true) {
      loadMoreNews(countryName: locationProvider.val!);
    }
  }

  @override
  void initState() {
    super.initState();
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    newsProvider = Provider.of<NewsProvider>(context, listen: false);

    _future = getNews();
    _controller = ScrollController()..addListener(_scrollListener);
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
                    childList: _selectLocationBottomSheetUI.showSelectLocationBottomSheet(),
                    heading: 'Choose your Location',
                    applyFilter: () {
                      Navigator.pop(context);
                      locationProvider.setCountry(countries[
                      countries.indexWhere((element) =>
                      element['val'] == locationProvider.val!)]
                      ['location']!);
                      _future = getNews(countryName: locationProvider.val!);
                    });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:16,vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 8,),
                    Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                          return Text(
                            locationProvider.currentCountry!,
                            style: const TextStyle(color: Colors.white, fontSize: 14,decoration: TextDecoration.underline,),
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
              applyFilter: () {},
              context: context,
              childList: _selectCategoryBottomSheetUI.showSelectCategoryBottomSheet(),
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
                  },
                  child: const TextFieldSearch(enabled: false)),
              //Top Headlines
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            Expanded(
                                child: NewsList(
                              controller: _controller,
                            )),
                            Consumer<NewsProvider>(
                              builder: (context, newsProvider, child) {
                                return Visibility(
                                    visible: newsProvider.fetchMore,
                                    child: const CircularProgressIndicator());
                              },
                            )
                          ],
                        );
                      } else {
                        return Text(snapshot.data.toString());
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
