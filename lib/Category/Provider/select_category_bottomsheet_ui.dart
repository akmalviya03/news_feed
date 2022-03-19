import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_provider.dart';
import '../../constants.dart';

//Multiple categories are not supported By NewsApi Top Headlines
class SelectCategoryBottomSheetUI {
  Widget showSelectCategoryBottomSheet() {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) => Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
              return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  title: Text(categories[index]['category']),
                  value: categories[index]['value'],
                  onChanged: (value) {
                    categories[index]['value'] = value!;
                    categoryProvider.setCategory(value ? categories[index]['category']: '');
                  });
            }));
  }
}
