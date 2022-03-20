//App Bar
// Container(
//   color: Theme.of(context).primaryColor,
//   child: Padding(
//     padding: const EdgeInsets.all(16),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           'MyNEWS',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         GestureDetector(
//           onTap: () {
//             _bottomSheetMethods.showCustomBottomSheet(
//               context: context,
//                 childList: ListView.builder(
//                     itemCount: countries.length,
//                     itemBuilder: (context, index) =>
//                         Consumer<LocationProvider>(
//                           builder:
//                               (context, locationProvider, child) {
//                             return RadioListTile(
//                                 controlAffinity:
//                                     ListTileControlAffinity
//                                         .trailing,
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text(countries[index]
//                                     ['location']!),
//                                 value: countries[index]['val']!,
//                                 groupValue: locationProvider.val,
//                                 onChanged: (value) {
//                                   locationProvider
//                                       .setVal(value.toString());
//                                 });
//                           },
//                         )),
//                 heading: 'Choose your Location',
//                 applyFilter: () {
//                   Navigator.pop(context);
//                   locationProvider.setCountry(countries[
//                       countries.indexWhere((element) =>
//                           element['val'] ==
//                           locationProvider.val!)]['location']!);
//                   _future =
//                       getNews(countryName: locationProvider.val!);
//                 });
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'LOCATION',
//                 style:
//                     TextStyle(color: Colors.white, fontSize: 14),
//               ),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Colors.white,
//                     size: 14,
//                   ),
//                   Consumer<LocationProvider>(builder:
//                       (context, locationProvider, child) {
//                     return Text(
//                       locationProvider.currentCountry!,
//                       style: const TextStyle(
//                           color: Colors.white, fontSize: 14),
//                     );
//                   })
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
//TextField

// String dropdownValue = 'Newest';
// Row(
//   children: [
//     Text(
//       'Sort: ',
//       style: TextStyle(
//           color: Theme.of(context).primaryColorDark,
//           fontSize: 14),
//     ),
//     DropdownButton<String>(
//         value: dropdownValue,
//         onChanged: (newValue) {
//           setState(() {
//             dropdownValue = newValue!;
//           });
//         },
//         items: const [
//           DropdownMenuItem<String>(
//             value: 'Popular',
//             child: Text('Popular'),
//           ),
//           DropdownMenuItem<String>(
//             value: 'Newest',
//             child: Text('Newest'),
//           ),
//           DropdownMenuItem<String>(
//             value: 'Oldest',
//             child: Text('Oldest'),
//           ),
//         ]),
//   ],
// )