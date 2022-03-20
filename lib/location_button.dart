import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Location/Provider/location_provider.dart';
class LocationButton extends StatelessWidget {
  const LocationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(
            width: 8,
          ),
          Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return Text(
                  locationProvider.currentCountry!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                );
              })
        ],
      ),
    );
  }
}