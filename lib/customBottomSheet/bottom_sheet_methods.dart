import 'package:flutter/material.dart';

import 'custom_bottom_sheet_ui.dart';
class BottomSheetMethods {
  Future showCustomBottomSheet(
      {required Widget childList,
        required String heading,
        required VoidCallback applyFilter,required BuildContext context}) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return CustomBottomSheet(
            childWidget: Column(
              children: [
                Expanded(child: childList),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                      onPressed: applyFilter,
                      child: const Text('Apply Filter'),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8)),
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