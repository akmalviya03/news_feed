import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/date_formatter.dart';
import 'details_page.dart';
import '../newsModels/articles_model.dart';

class NewsCard extends StatelessWidget {
   NewsCard({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Articles article;
  final DateFormatter _dateFormatter=DateFormatter();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  DetailsPage(article: article, dateFormatter: _dateFormatter,)));
      },
      child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                              article.source?.name ?? 'Default Source',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              article.description ?? 'Default Description',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                         article.publishedAt !=null ? _dateFormatter.formatMyDate(article.publishedAt!): 'Error While fetching date',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Hero(
                    tag: article.urlToImage ?? 'https://www.drodd.com/images14/black7.jpg',
                      child: ExtendedImage.network(
                        article.urlToImage ?? 'https://www.drodd.com/images14/black7.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        shape: BoxShape.rectangle,
                        cache: true,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
