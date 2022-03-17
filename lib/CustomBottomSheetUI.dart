import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    Key? key, required this.childWidget,
  }) : super(key: key);

  final Widget childWidget;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.015,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const Text(
              'Filter by sources',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 2,
              height: 16,
            ),
            Expanded(
              child: widget.childWidget,
            )
          ],
        ),
      ),
    );
  }
}
