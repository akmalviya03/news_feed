import 'package:flutter/material.dart';

import 'newsCard.dart';

class NewsList extends StatelessWidget {
  const NewsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) => const NewsCard());
  }
}
