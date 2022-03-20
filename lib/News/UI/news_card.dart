import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed/Utility/date_formatter.dart';
import 'details_page.dart';
import '../newsModels/articles_model.dart';

class NewsCard extends StatelessWidget {
  NewsCard({
    Key? key,
    required Articles article,
  })  : _article = article,
        super(key: key);

  final Articles _article;
  final DateFormatter _dateFormatter = DateFormatter();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsPage(
                  article: _article,
                  dateFormatter: _dateFormatter,
                )));
      },
      child: Card(
          elevation: 4,
          margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04, vertical: MediaQuery.of(context).size.width*0.02),
          child: Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width*0.04),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _article.source?.name ?? 'Default Source',
                              style:  GoogleFonts.montserrat(
                                  fontSize: MediaQuery.of(context).size.width*0.04,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                             SizedBox(
                              height: MediaQuery.of(context).size.width*0.02,
                            ),
                            Text(
                              _article.description ?? 'Default Description',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style:  GoogleFonts.montserrat(
                                fontSize:  MediaQuery.of(context).size.width*0.035,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _article.publishedAt != null
                              ? _dateFormatter
                                  .formatMyDate(_article.publishedAt!)
                              : 'Error While fetching date',
                          style:  GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width*0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(
                    width: MediaQuery.of(context).size.width*0.02,
                  ),
                  Flexible(
                    child: Hero(
                      tag: _article.urlToImage ??
                          'https://www.drodd.com/images14/black7.jpg',
                      child: ExtendedImage.network(
                        _article.urlToImage ??
                            'https://www.drodd.com/images14/black7.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        shape: BoxShape.rectangle,
                        cache: true,
                        borderRadius: BorderRadius.all( Radius.circular(MediaQuery.of(context).size.width*0.02)),
                        //cancelToken: cancellationToken,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
