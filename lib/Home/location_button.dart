import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Location/Provider/location_provider.dart';
class LocationButton extends StatelessWidget {
  const LocationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04, vertical: MediaQuery.of(context).size.width*0.02),
      child: Row(
        children: [
           Icon(
            Icons.location_on,
            color: Colors.white,
            size: MediaQuery.of(context).size.width*0.035,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.02,
          ),
          Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return Text(
                  locationProvider.currentCountry!,
                  style:  GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width*0.035,
                    decoration: TextDecoration.underline,
                  ),
                );
              })
        ],
      ),
    );
  }
}