import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/drug_model.dart';
import '../ui/drugs_detail.dart';

//this code is copy of drug list and it added filter function from Category

class DrugsListFilter extends StatefulWidget {
  @override
  _DrugsListFilterState createState() => _DrugsListFilterState();
}

class _DrugsListFilterState extends State<DrugsListFilter> {
  late List<Drug> allDrugs;
  bool isFirstTime = true;

  // Define a new list to store filtered drugs
  List<dynamic> filteredDrugs = [];


  List<dynamic> displayedDrugs = [];
  TextEditingController searchController = TextEditingController();

  List<String> categories = [];
  List<String> types = [];

  String? selectedCategory = 'All';
  // Define selected filter criteria for type
  String? selectedType = 'All';

  @override
  void initState() {
    super.initState();
    allDrugs = [];
    filteredDrugs = List.from(allDrugs);
    loadData();
  }

  void _filterDrugsByCategory() {
    if (selectedCategory == null || selectedCategory == 'All') {
      // If no category is selected or 'All' is selected, show all drugs
      setState(() {
        filteredDrugs = List.from(allDrugs);
        _updateTypesList(selectedCategory!);
        selectedType = 'All';
      });
    } else {
      // Filter drugs based on the selected category
      setState(() {
        filteredDrugs = allDrugs
            .where((drug) => drug.category == selectedCategory)
            .toList();
        _updateTypesList(selectedCategory!); // Update types list
        selectedType = 'All';
      });
    }
  }

  void _filterDrugsByType() {
    if (selectedType == null || selectedType == 'All') {
      // If no type is selected or 'All' is selected, show drugs based on selected category
      _filterDrugsByCategory();
    } else {
      // Filter drugs based on the selected type
      setState(() {
        filteredDrugs = allDrugs
            .where((drug) => drug.category == selectedCategory && drug.type == selectedType)
            .toList();
      });
    }
  }

  void _updateTypesList(String selectedCategory) {
    if (selectedCategory == null || selectedCategory == 'All') {
      // If no category is selected or 'All' is selected, display all types
      setState(() {
        types = allDrugs.map((drug) => drug.type).toSet().toList();
        types.sort((a, b) => a.compareTo(b));
      });
    } else {
      // Filter types based on the selected category
      setState(() {
        types = allDrugs
            .where((drug) => drug.category == selectedCategory)
            .map((drug) => drug.type)
            .toSet()
            .toList();
        types.sort((a, b) => a.compareTo(b));
      });
    }
  }


  Future<void> loadData() async {
    // Initialize _prefs first
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read isFirstTime
    isFirstTime = prefs.getBool('isFirstTime') ?? true;

    final file = File('${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');

    if (await file.exists()) {
      final jsonData = await file.readAsString();
      setState(() {
        allDrugs = (json.decode(jsonData) as List).map((item) => Drug.fromJson(item)).toList();
        filteredDrugs = List.from(allDrugs);
        displayedDrugs = List.from(allDrugs);

      });

      // Get unique categories from all drugs
      categories = allDrugs.map((drug) => drug.category).toSet().toList();
      categories.sort((a,b) => a.compareTo(b));

      //Get unique type from all drugs
      types = allDrugs.map((drug) => drug.type).toSet().toList();
      //sort list of types by Alphabetically
      types.sort((a, b) => a.compareTo(b));


    } else {
      if (isFirstTime) {
        // Show dialog for the first time to ask user to download
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Download Data'),
              content: const Text('Do you want to download the data from the internet?'),
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
    final response = await http.get(Uri.parse('https://drive.google.com/uc?export=download&id=1kGZWVeMAPdqRhWWsrvqPg1lYUUm7TnHz'));

    if (response.statusCode == 200) {
      final file = File('${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');
      await file.writeAsString(response.body);

      setState(() {
        allDrugs = (json.decode(response.body) as List).map((item) => Drug.fromJson(item)).toList();
        displayedDrugs = List.from(allDrugs);
      });

      // Show dialog to indicate the data has been downloaded
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Downloaded'),
            content: const Text('The data has been downloaded from the internet.'),
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
            .where((drug) => drug.name.toLowerCase().contains(query.toLowerCase()))
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
            //start of filter by category
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Filter by Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        _filterDrugsByCategory();
                      });
                    },
                    items: ['All', ...categories].map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    icon: Icon(Icons.arrow_drop_down, size: 30, color: Colors.red),
                  ),
                ),
              ],
            ),
            //end of filter by category

            // Add filter by type dropdown
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Filter by Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  // DropdownButtonFormField<String>(
                  //   value: selectedType,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedType = value;
                  //       _filterDrugsByType();
                  //     });
                  //   },
                  //   items: ['All', ...types].map((type) {
                  //     return DropdownMenuItem<String>(
                  //       value: type,
                  //       child: Text(type),
                  //     );
                  //   }).toList(),
                  //   icon: Icon(Icons.arrow_drop_down, size: 30, color: Colors.red),
                  // ),
                  // Update the items for "Filter by Types" dropdown based on the updated types list
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                        _filterDrugsByType();
                      });
                    },
                    items: ['All', ...types].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    icon: Icon(Icons.arrow_drop_down, size: 30, color: Colors.red),
                  ),
                ),
              ],
            ),
            //end of filter by type


            Expanded(
              child: allDrugs.isEmpty
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.separated(
               // itemCount: displayedDrugs.length,
                itemCount: filteredDrugs.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.grey,
                  );
                },
                itemBuilder: (context, index) {
                  //final drug = displayedDrugs[index];
                  final drug = filteredDrugs[index];
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
                          builder: (context) => DrugDetailScreen(drug: drug),
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
