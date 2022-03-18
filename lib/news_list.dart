import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'newsProvider.dart';
import 'news_card.dart';

class NewsList extends StatelessWidget {
  const NewsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return ListView.builder(
            itemCount: newsProvider.articles?.length,
            itemBuilder: (context, index) => NewsCard(
                 article: newsProvider.articles![index],
                ));
      },
    );
  }
}
