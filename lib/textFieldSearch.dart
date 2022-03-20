import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: TextField(
          autofocus: autoFocus,
            enabled: enabled,
            onChanged: callback,
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
      ),
    );
  }
}
