import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldSearch extends StatelessWidget {
  final Function(String) callback;
  final bool autoFocus;
  final bool enabled;

  const TextFieldSearch({
    Key? key,
    this.enabled = true,
    required this.callback,
    this.autoFocus = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04, vertical: MediaQuery.of(context).size.width*0.04),
        child: TextField(
          autofocus: autoFocus,
            enabled: enabled,
            onChanged: callback,
            keyboardType: TextInputType.name,
            style:  GoogleFonts.montserrat(fontSize: MediaQuery.of(context).size.width*0.035),
            decoration: InputDecoration(
              hintText: 'Search for news,topics...',
              hintStyle: GoogleFonts.montserrat(fontSize: MediaQuery.of(context).size.width*0.035),
              fillColor: Theme.of(context).backgroundColor,
              filled: true,
              suffixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColorDark,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.02),
                borderSide: BorderSide.none,
              ),
            ),
            cursorColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
