import 'package:flutter/material.dart';

import 'newsModels/articles_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.article}) : super(key: key);
  final Articles article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: article.urlToImage ??
                  'https://www.drodd.com/images14/black7.jpg',
              child: Stack(
                children: [
                  Image.network(
                    article.urlToImage ??
                        'https://www.drodd.com/images14/black7.jpg',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black])),
                    child: Text(
                      article.title ?? 'Some Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source?.name ?? 'Default Source',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      article.publishedAt ?? 'Default Source',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(article.content ?? 'Default Content'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
