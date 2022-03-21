import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    Key? key, required this.childWidget, required this.heading,
  }) : super(key: key);

  final Widget childWidget;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.04),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.015,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.04)),
                ),
              ),
            ),
             Text(
             heading,
              style:  GoogleFonts.montserrat(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.bold),
            ),
             Divider(
              thickness: 2,
              height: MediaQuery.of(context).size.width*0.04,
            ),
            Expanded(
              child: childWidget,
            )
          ],
        ),
      ),
    );
  }
}
