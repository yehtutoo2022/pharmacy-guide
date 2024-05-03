import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/drug_model.dart';
import '../data/hitory_provider.dart';

class DrugsListFilter extends StatefulWidget {
  @override
  _DrugsListFilterState createState() => _DrugsListFilterState();
}

class _DrugsListFilterState extends State<DrugsListFilter> {
  late List<Drug> allDrugs;
  bool isFirstTime = true;

  List<dynamic> displayedDrugs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allDrugs = []; // Initialize allDrugs as an empty list
    loadData();
  }

  Future<void> loadData() async {
    // Initialize _prefs first
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read isFirstTime
    isFirstTime = prefs.getBool('isFirstTime') ?? true;

    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');

    if (await file.exists()) {
      final jsonData = await file.readAsString();
      setState(() {
        allDrugs = (json.decode(jsonData) as List)
            .map((item) => Drug.fromJson(item))
            .toList();
        displayedDrugs = List.from(allDrugs);
      });
    } else {
      if (isFirstTime) {
        // Show dialog for the first time to ask user to download
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Download Data'),
              content: const Text(
                  'Do you want to download the data from the internet?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await downloadData();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> downloadData() async {
    final response = await http.get(Uri.parse(
        'https://drive.google.com/uc?export=download&id=1kGZWVeMAPdqRhWWsrvqPg1lYUUm7TnHz'));

    if (response.statusCode == 200) {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');
      await file.writeAsString(response.body);

      setState(() {
        allDrugs = (json.decode(response.body) as List)
            .map((item) => Drug.fromJson(item))
            .toList();
        displayedDrugs = List.from(allDrugs);
      });

      // Show dialog to indicate the data has been downloaded
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Downloaded'),
            content:
                const Text('The data has been downloaded from the internet.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Update the flag indicating that the file has been downloaded
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isFirstTime', false);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _searchDrugs(String query) {
    if (query.isEmpty) {
      // If the search query is empty, display all drugs
      setState(() {
        displayedDrugs = List.from(allDrugs);
      });
    } else {
      // Filter drugs based on the search query
      setState(() {
        displayedDrugs = allDrugs
            .where(
                (drug) => drug.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Drugs List'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: _searchDrugs,
                decoration: InputDecoration(
                  hintText: 'Search drugs...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      _searchDrugs('');
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: allDrugs.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                      itemCount: displayedDrugs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Colors.grey,
                        );
                      },
                      itemBuilder: (context, index) {
                        final drug = displayedDrugs[index];
                        return ListTile(
                          title: Text(
                            drug.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pyidaungsu',
                            ),
                          ),
                          subtitle: Text(
                            'Category: ${drug.category}',
                            style: TextStyle(
                              fontFamily: 'Pyidaungsu',
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DrugDetailScreen(drug: drug),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
