import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_bottom_sheet_ui.dart';

class BottomSheetMethods {
  Future showCustomBottomSheet(
      {required Widget childList,
      required String heading,
      required VoidCallback applyFilter,
      required BuildContext context}) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.04),
            topRight: Radius.circular(MediaQuery.of(context).size.width * 0.04),
          ),
        ),
        builder: (builder) {
          return CustomBottomSheet(
            childWidget: Column(
              children: [
                Expanded(child: childList),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.04),
                  child: ElevatedButton(
                      onPressed: applyFilter,
                      child: Text(
                        'Apply Filter',
                        style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.03),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.04,
                                  vertical: MediaQuery.of(context).size.width *
                                      0.02)),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor))),
                ),
              ],
            ),
            heading: heading,
          );
        });
  }
}
