import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Views/home_page.dart';
import 'package:news_feed/Models/articles_model.dart';
import 'package:news_feed/Providers/search_provider.dart';
import 'package:news_feed/Components/text_field_search.dart';
import 'package:provider/provider.dart';
import '../Providers/newsProvider.dart';
import '../Components/news_card.dart';
import '../Components/center_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final NewsProvider newsProvider;
  late final SearchProvider searchProvider;
  late int counter = 0;

  @override
  void initState() {
    super.initState();
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
                        newsProvider.articles?.where((element) {
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
                    counter = 1;
                    searchProvider.fillSearchedArticles(filteredList!);
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
                            text: counter < 1
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
