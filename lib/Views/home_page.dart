import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Views/search_page.dart';
import 'package:news_feed/Components/text_field_search.dart';
import 'package:provider/provider.dart';
import '../Components/center_text.dart';
import '../Components/location_button.dart';
import '../Providers/retry_provider.dart';
import '../Providers/news_provider.dart';
import '../Components/news_list.dart';

class HomePage extends StatelessWidget {

  late NewsProvider _newsProvider;
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _newsProvider = Provider.of<NewsProvider>(context, listen: false);
    _newsProvider.initializeValues(context);
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
                _newsProvider.showSelectLocationBottomSheet();
              },
              child: const LocationButton(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            _newsProvider.showSelectCategoryBottomSheet();
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
                    future: _newsProvider.future,
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
                                  child: Consumer<RetryProvider>(
                                      builder: (context, retryProvider, child) {
                                        if(retryProvider.retryHomePage == false){
                                          return newsProvider.articles!.isNotEmpty
                                              ? NewsList(
                                            controller: _newsProvider.controller,
                                          )
                                              : const CenterText(
                                            text:
                                            'OOPS! We ran out of articles',
                                          );
                                        }else{
                                          return Column(
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
                                                      if (_newsProvider.internetWorking == true) {
                                                        _newsProvider.future = _newsProvider.getNews();
                                                      }
                                                  },
                                                  child: Text(
                                                    'Retry',
                                                    style: GoogleFonts
                                                        .montserrat(),
                                                  ))
                                            ],
                                          );
                                        }

                                  }),
                                ),
                                Consumer<RetryProvider>(
                                    builder: (context, retryProvider, child) {
                                  if (retryProvider.retryPagination == false) {
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
                                          if (_newsProvider.internetWorking == true) {
                                            _newsProvider.future = _newsProvider.loadMoreNews();
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
