import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/textFieldSearch.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'custom_bottom_sheet_ui.dart';
import 'location_provider.dart';
import 'networkApis/news_api.dart';
import 'newsModels/news_list_model.dart';
import 'newsProvider.dart';
import 'news_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future showCustomBottomSheet(
      {required Widget childList,
      required String heading,
      required VoidCallback applyFilter}) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return CustomBottomSheet(
            childWidget: Column(
              children: [
                Expanded(child: childList),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                      onPressed: applyFilter,
                      child: Text('Apply Filter'),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8)),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor))),
                ),
              ],
            ),
            heading: heading,
          );
        });
  }

  final NewsApi _newsApi = NewsApi();
  String dropdownValue = 'Newest';
  late Future _future;
  late ScrollController _controller;
  late NewsListModel newsListModel;

  Future getNews({String countryName = 'in'}) async {
    newsListModel = await _newsApi.getCountryNews(countryName: countryName);
    Provider.of<NewsProvider>(context, listen: false)
        .initializeArticlesList(newsListModel.articles);
    Provider.of<NewsProvider>(context, listen: false)
        .setTotalArticles(newsListModel.totalResults);

    return 'Done';
  }

  Future loadMoreNews({String countryName = 'in'}) async {
    if (((Provider.of<NewsProvider>(context, listen: false).totalArticles)! >
            (Provider.of<NewsProvider>(context, listen: false)
                .totalArticlesInList)) &&
        Provider.of<NewsProvider>(context, listen: false).fetchMore != true) {
      Provider.of<NewsProvider>(context, listen: false).fetching();

      newsListModel = await _newsApi.getCountryNews(
          page: Provider.of<NewsProvider>(context, listen: false).currentPage);

      Provider.of<NewsProvider>(context, listen: false)
          .addMoreArticlesToList(newsListModel.articles);

      Provider.of<NewsProvider>(context, listen: false).fetchingDone();
    }
    return 'Done';
  }

  void _scrollListener() {
    if (_controller.position.extentAfter == 0 &&
        Provider.of<NewsProvider>(context, listen: false).fetchMore != true) {
      loadMoreNews(
          countryName:
              Provider.of<LocationProvider>(context, listen: false).val!);
    }
  }

  @override
  void initState() {
    super.initState();
    _future = getNews();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            bool? selected = true;
            showCustomBottomSheet(
                heading: 'Filter by sources',
                childList: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Male"),
                      value: selected,
                      onChanged: (value) {
                        if (kDebugMode) {
                          print(value);
                        }
                        setState(() {
                          selected = value;
                        });
                      }),
                ),
                applyFilter: () {});
          },
          child: const Icon(Icons.filter_alt_outlined),
        ),
        body: SafeArea(
          child: Column(
            children: [
              //App Bar
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'MyNEWS',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCustomBottomSheet(
                              childList: ListView.builder(
                                  itemCount: countries.length,
                                  itemBuilder: (context, index) =>
                                      Consumer<LocationProvider>(
                                        builder:
                                            (context, locationProvider, child) {
                                          return RadioListTile(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(countries[index]
                                                  ['location']!),
                                              value: countries[index]['val']!,
                                              groupValue: locationProvider.val,
                                              onChanged: (value) {
                                                locationProvider
                                                    .setVal(value.toString());
                                              });
                                        },
                                      )),
                              heading: 'Choose your Location',
                              applyFilter: () {
                                Navigator.pop(context);
                                Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .setCountry(countries[countries.indexWhere(
                                        (element) =>
                                            element['val'] ==
                                            Provider.of<LocationProvider>(
                                                    context,
                                                    listen: false)
                                                .val!)]['location']!);
                                _future = getNews(
                                    countryName: Provider.of<LocationProvider>(
                                            context,
                                            listen: false)
                                        .val!);
                              });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'LOCATION',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                Consumer<LocationProvider>(builder:
                                    (context, locationProvider, child) {
                                  return Text(
                                    locationProvider.currentCountry!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  );
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //TextField
              GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print('Hello');
                    }
                  },
                  child: const TextFieldSearch(enabled: false)),
              //Top Headlines
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Headlines',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          'Sort: ',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14),
                        ),
                        DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Popular',
                                child: Text('Popular'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Newest',
                                child: Text('Newest'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Oldest',
                                child: Text('Oldest'),
                              ),
                            ]),
                      ],
                    )
                  ],
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
