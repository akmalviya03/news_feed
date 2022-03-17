import 'package:flutter/material.dart';
import 'package:news_feed/textFieldSearch.dart';
import 'CustomBottomSheetUI.dart';
import 'newsList.dart';
import 'package:news_feed/Constants.dart';
void main() {
  runApp(const NewsFeedApp());
}

class NewsFeedApp extends StatelessWidget {
  const NewsFeedApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xff0C54BE),
        primaryColorDark: const Color(0xff303F60),
        scaffoldBackgroundColor: const Color(0xffF5F9FD),
        backgroundColor: const Color(0xFFCED3DC),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String val = countries[0];
  Future showCustomBottomSheet({required Widget childList}) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return CustomBottomSheet(
            childWidget: childList,
          );
        });
  }

  String dropdownValue = 'Newest';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            bool? selected = true;
            showCustomBottomSheet(
                childList: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  title: Text("Male"),
                  value: selected,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      selected = value;
                    });
                  }),
            ));
          },
          child: const Icon(Icons.filter_alt_outlined),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'MyNEWS',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            showCustomBottomSheet(
                                childList: ListView.builder(
                                  itemCount: countries.length,
                                  itemBuilder: (context, index) => RadioListTile(
                                      controlAffinity: ListTileControlAffinity.trailing,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(countries[index]),
                                      value: countries[index],
                                      groupValue: val,
                                      onChanged: (value) {
                                        setState(() {
                                          val = value.toString();
                                        });
                                      }),
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'LOCATION',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  Text(
                                    'India',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          print('Hello');
                        },
                        child: const TextFieldSearch(enabled: false)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Headlines',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                'Sort: ',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 14),
                              ),
                              DropdownButton<String>(
                                  value: dropdownValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: 'Popular',
                                      child: Text('Popular'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Newest',
                                      child: Text('Newest'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Oldest',
                                      child: Text('Oldest'),
                                    ),
                                  ]),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const NewsList()
              ],
            ),
          ),
        ));
  }
}
