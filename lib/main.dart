import 'package:flutter/material.dart';
import 'package:news_feed/Category/Provider/category_provider.dart';
import 'package:news_feed/Location/Provider/location_provider.dart';
import 'Search/SearchProvider.dart';
import 'home_page.dart';
import 'News/Provider/newsProvider.dart';
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
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),

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


