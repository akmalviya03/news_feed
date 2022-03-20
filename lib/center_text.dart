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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(),
          )),
    );
  }
}