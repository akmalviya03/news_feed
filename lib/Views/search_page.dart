import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Views/home_page.dart';
import 'package:news_feed/Models/articles_model.dart';
import 'package:news_feed/Providers/search_provider.dart';
import 'package:news_feed/Components/text_field_search.dart';
import 'package:provider/provider.dart';
import '../Providers/news_provider.dart';
import '../Components/news_card.dart';
import '../Components/center_text.dart';

class SearchPage extends StatelessWidget {
   const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsProvider _newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onVerticalDragEnd: (de) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onHorizontalDragStart: (de) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search',
            style: GoogleFonts.montserrat(fontSize: MediaQuery.of(context).size.width*0.035),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            Hero(
                tag: 'Search',
                child: TextFieldSearch(
                  autoFocus: true,
                  callback: (string) {
                    List<Articles>? filteredList =
                        _newsProvider.articles?.where((element) {
                      return ((element.content ?? "")
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          (element.title ?? "")
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          (element.description ?? "")
                              .toLowerCase()
                              .contains(string.toLowerCase()));
                    }).toList();
                    if(_searchProvider.openedFirstTime){
                      _searchProvider.setOpenedFirstTimeToFalse();
                    }
                    _searchProvider.fillSearchedArticles(filteredList!);
                  },
                )),
            Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                return Expanded(
                    child: searchProvider.getSearchedArticles.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                searchProvider.getSearchedArticles.length,
                            itemBuilder: (context, index) => NewsCard(
                                  article:
                                      searchProvider.getSearchedArticles[index],
                                ))
                        : CenterText(
                            text: searchProvider.openedFirstTime == true
                                ? 'We have plenty of news articles you can search from them'
                                : 'OOPS! We have no item with this name'));
              },
            )
          ],
        ),
      ),
    );
  }
}
