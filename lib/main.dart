import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/newsModels/news_list_model.dart';
import 'package:news_feed/textFieldSearch.dart';
import 'custom_bottom_sheet_ui.dart';
import 'networkApis/news_api.dart';
import 'newsProvider.dart';
import 'news_list.dart';
import 'package:news_feed/Constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const NewsFeedApp());
}

class NewsFeedApp extends StatelessWidget {
  const NewsFeedApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xff0C54BE),
          primaryColorDark: const Color(0xff303F60),
          scaffoldBackgroundColor: const Color(0xffF5F9FD),
          backgroundColor: const Color(0xFFCED3DC),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String val = countries[0];
  Future showCustomBottomSheet({required Widget childList}) {
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
            childWidget: childList,
          );
        });
  }

  final NewsApi _newsApi = NewsApi();
  String dropdownValue = 'Newest';
  late Future _future;

  Future getNews() async {
    NewsListModel newsListModel = await _newsApi.getCountryNews();
    Provider.of<NewsProvider>(context,listen: false).initializeArticlesList(newsListModel.articles);
    return 'Done';
  }

  @override
  void initState() {
    super.initState();
    _future = getNews();
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
            ));
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
                            itemBuilder: (context, index) => RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                title: Text(countries[index]),
                                value: countries[index],
                                groupValue: val,
                                onChanged: (value) {
                                  setState(() {
                                    val = value.toString();
                                  });
                                }),
                          ));
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
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                Text(
                                  'India',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
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
                        return const NewsList();
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
