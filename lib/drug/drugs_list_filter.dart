import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../data/drug_model.dart';
import '../data/history_provider.dart';
import 'drugs_detail.dart';

class DrugsListFilter extends StatefulWidget {
  const DrugsListFilter({super.key});

  @override
  _DrugsListFilterState createState() => _DrugsListFilterState();
}

class _DrugsListFilterState extends State<DrugsListFilter> {
  late List<Drug> allDrugs;
  bool isFirstTime = true;
  bool downloadingData = false;
  double downloadingProgress = 0.0;

  List<dynamic> filteredDrugs = [];
  List<dynamic> displayedDrugs = [];
  TextEditingController searchController = TextEditingController();

  List<String> categories = [];
  List<String> types = [];

  String? selectedCategory = 'All';
  String? selectedType = 'All';

  bool searchDrugsByBrandName = true;

  @override
  void initState() {
    super.initState();
    initialization();
    allDrugs = [];
    filteredDrugs = List.from(allDrugs);
    loadData();
  }

  void initialization() async {
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  void _searchDrugsByBrandName(String query) {
    if (query.isEmpty) {
      // If the search query is empty, display all drugs
      setState(() {
        displayedDrugs = List.from(filteredDrugs);
      });
    } else {
      // Filter drugs based on the search query
      setState(() {
        displayedDrugs = filteredDrugs
            .where((drug) =>
                   drug.name.toLowerCase().contains(query.toLowerCase())
        )
            .toList();
      });
    }
  }

  void _searchDrugsByGenericName(String query) {
    if (query.isEmpty) {
      // If the search query is empty, display all drugs
      setState(() {
        displayedDrugs = List.from(filteredDrugs);
      });
    } else {
      // Filter drugs based on the search query
      setState(() {
        displayedDrugs = filteredDrugs
            .where((drug) =>
            drug.ingredients.toLowerCase().contains(query.toLowerCase())
        )
            .toList();
      });
    }
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
    //add to work search and filter
    _searchDrugsByBrandName(searchController.text);
  }

  void _filterDrugsByType() {
    if (selectedType == null || selectedType == 'All') {
      // If no type is selected or 'All' is selected, show drugs based on selected category
      _filterDrugsByCategory();
    } else {
      // Filter drugs based on the selected type
      setState(() {
        filteredDrugs = allDrugs
            .where((drug) =>
                drug.category == selectedCategory && drug.type == selectedType)
            .toList();
      });
    }
    //add to work search and filter
    _searchDrugsByBrandName(searchController.text);
  }

  void _updateTypesList(String selectedCategory) {
    if (selectedCategory == 'All') {
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

    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');

    if (await file.exists()) {
      final jsonData = await file.readAsString();
      setState(() {
        allDrugs = (json.decode(jsonData) as List)
            .map((item) => Drug.fromJson(item))
            .toList();
        filteredDrugs = List.from(allDrugs);
        displayedDrugs = List.from(allDrugs);
      });

      // Get unique categories from all drugs
      categories = allDrugs.map((drug) => drug.category).toSet().toList();
      categories.sort((a, b) => a.compareTo(b));

      //Get unique type from all drugs
      types = allDrugs.map((drug) => drug.type).toSet().toList();
      //sort list of types by Alphabetically
      types.sort((a, b) => a.compareTo(b));
    } else {
      if (isFirstTime) {
        Vibration.vibrate(duration: 100);
        // Show dialog for the first time to ask user to download
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Download Database'),
              content: const Text(
                  'Do you want to download the database from the internet?'),
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

  //this function is to download Data from GitHub and save it to sharePreference as drugs_data.json
  Future<void> downloadData() async {
    //git show Burmese font correctly

    String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/drugs_data.json';

    //googleDrive link is not show Burmese font Correctly
   // String googleDriveLink = 'https://drive.google.com/uc?export=download&id=1kGZWVeMAPdqRhWWsrvqPg1lYUUm7TnHz';
    setState(() {
      downloadingData = true; // Set downloading status to true
    });

    final response = await http.get(
        Uri.parse(githubRawUrl),
     // Uri.parse(googleDriveLink),
    );

    if (response.statusCode == 200) {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');
      await file.writeAsString(response.body);

      setState(() {
        allDrugs = (json.decode(response.body) as List)
            .map((item) => Drug.fromJson(item))
            .toList();
        displayedDrugs = List.from(allDrugs);
        downloadingData = false; // Set downloading status to false when finished
      });

      // Calculate progress percentage based on the received content length
      final contentLength = response.headers['content-length'];
      final totalBytes = contentLength == null ? 0 : int.parse(contentLength);
      downloadingProgress = totalBytes > 0 ? response.bodyBytes.length / totalBytes : 0;

      Vibration.vibrate(duration: 100);
      // Show dialog to indicate the data has been downloaded
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Database Downloaded'),
            content:
                const Text('The database has been downloaded from the internet.'),
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
      setState(() {
        downloadingData = false; // Set downloading status to false on failure
      });
      throw Exception('Failed to load data');
    }
  }


  void _showFilterDialog() {
    Vibration.vibrate(duration: 100);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Filter Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //filter by category title
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Filter by Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //filter by category list
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        _filterDrugsByCategory();
                        _updateTypesList(selectedCategory!);
                        // Reset selectedType when category changes
                        selectedType = 'All';
                      });
                    },
                    items: ['All', ...categories].map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    icon:  Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blue[200],
                    ),
                  ),

                  // Filter by Type title
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Filter by Dosage Form',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //filter by type list
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
                        child: Text(
                          type,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    icon:  Icon(Icons.arrow_drop_down,
                        size: 30, color: Colors.blue[200]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final HistoryProvider historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          // Add the logo to the leading property
          // leading: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          // ),
          title: const Text(
              'MM Pharmacy Guide',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue[800],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                // this can use two search methods
                onChanged: (query) {
                  if (searchDrugsByBrandName) {
                    _searchDrugsByBrandName(query);
                  } else {
                    _searchDrugsByGenericName(query);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search drugs',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0), // Adjust the radius as needed
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear_all),
                        //this can use two search methods
                        onPressed: () {
                          searchController.clear();
                          if (searchDrugsByBrandName) {
                            _searchDrugsByBrandName('');
                          } else {
                            _searchDrugsByGenericName('');
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_alt),
                        color: Colors.blue[800],
                        onPressed: () {
                          _showFilterDialog();
                        },
                      ),
                    ],
                  ),
                ),

              ),
            ),
            //this row is for user switching
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  searchDrugsByBrandName ? 'Search by Brand Name' : 'Search by Generic Name',
                  style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic
                  ),
                ),
                Switch(
                  value: searchDrugsByBrandName,
                  onChanged: (value) {
                    setState(() {
                      searchDrugsByBrandName = value;
                      searchController.clear();
                    });
                  },
                  activeColor: Colors.grey,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  activeTrackColor: Colors.grey[200],
                ),
              ],
            ),
            if (downloadingData) // Show progress indicator if data is being downloaded
              LinearProgressIndicator(
                backgroundColor: Colors.blue[100], // Background color
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // Color of the progress indicator
                minHeight: 10, // Minimum height of the progress indicator
                value: downloadingProgress, // Set to null to indicate an indeterminate progress indicator
              ),
            Expanded(
              child: allDrugs.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                      itemCount: displayedDrugs.length,
                      // itemCount: filteredDrugs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Colors.grey,
                        );
                      },
                      itemBuilder: (context, index) {
                        final drug = displayedDrugs[index];
                        // final drug = filteredDrugs[index];
                        return ListTile(
                          title: Text(
                            drug.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pyidaungsu',
                            ),
                          ),
                          subtitle: Text(
                           // 'Ingredients: ${drug.ingredients}',
                            drug.ingredients,
                            style: const TextStyle(
                              fontFamily: 'Pyidaungsu',
                            ),
                          ),
                          onTap: () {
                            //if tap on drug name, it will save to HistoryProvider
                            historyProvider.addToHistory(drug);
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

