import 'package:flutter/material.dart';
class TextFieldSearch extends StatelessWidget {

  final bool enabled;
  const TextFieldSearch({
    Key? key,
     this.enabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8),
      child: TextField(
          enabled: enabled,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Search for news,topics...',
            fillColor: Theme.of(context).backgroundColor,
            filled: true,
            suffixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColorDark,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          cursorColor: Theme.of(context).primaryColor),
    );
  }
}