import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Utility/constants.dart';
import '../Provider/location_provider.dart';

class SelectLocationBottomSheetUI {
  Widget showSelectLocationBottomSheet() {
    return ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) => Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    title: Text(countries[index]['location']!,style: GoogleFonts.montserrat(),),
                    value: countries[index]['val']!,
                    groupValue: locationProvider.val,
                    onChanged: (value) {
                      locationProvider.setVal(value.toString());
                    });
              },
            ));
  }
}
