import 'package:flutter/material.dart';
import 'package:news_feed/Providers/category_provider.dart';
import 'package:news_feed/Providers/location_provider.dart';
import 'Providers/search_provider.dart';
import 'Providers/retry_provider.dart';
import 'Views/home_page.dart';
import 'Providers/newsProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const NewsFeedApp());
}

//Project is structured on the basis of UI

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
        ChangeNotifierProvider(create: (_) => RetryProvider()),
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
