import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CenterText extends StatelessWidget {
  const CenterText({
    Key? key, required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
      child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(fontSize: MediaQuery.of(context).size.width*0.035),
          )),
    );
  }
}