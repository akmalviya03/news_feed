import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/newsProvider.dart';
import 'news_card.dart';

class NewsList extends StatelessWidget {
  const NewsList({
    Key? key, required ScrollController controller,
  }) :_controller=controller, super(key: key);

  final ScrollController _controller;
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return ListView.builder(
          controller: _controller,
            itemCount: newsProvider.articles?.length,
            itemBuilder: (context, index) => NewsCard(
                 article: newsProvider.articles![index],
                ));
      },
    );
  }
}
