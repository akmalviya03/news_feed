import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../Location/Provider/location_provider.dart';

class SelectCategoryBottomSheetUI{

  Widget showSelectCategoryBottomSheet(){
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) => CheckboxListTile(
          controlAffinity: ListTileControlAffinity.trailing,
          contentPadding: EdgeInsets.zero,
          title:  Text(categories[index]['category']),
          value: categories[index]['value'],
          onChanged: (value) {
            if (kDebugMode) {
              print(value);
            }
            categories[index]['value'] = value!;
          }),
    );
  }

}