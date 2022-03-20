import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Utility/date_formatter.dart';

import '../newsModels/articles_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage(
      {Key? key, required this.article, required DateFormatter dateFormatter})
      : _dateFormatter = dateFormatter,
        super(key: key);
  final Articles article;
  final DateFormatter _dateFormatter;
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
              child: Material(
                child: Stack(
                  children: [
                    ExtendedImage.network(
                      article.urlToImage ??
                          'https://www.drodd.com/images14/black7.jpg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                      cache: true,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black])),
                      child: Text(
                        article.title ?? 'Some Title',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                             GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
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
                      style:  GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      article.publishedAt != null
                          ? _dateFormatter.formatMyDate(article.publishedAt!)
                          : 'Error While fetching date',
                      style:  GoogleFonts.montserrat(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(article.content ?? 'Default Content',style: GoogleFonts.montserrat(),),
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
