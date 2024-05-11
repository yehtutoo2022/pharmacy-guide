import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/drug_model.dart';

class DrugRepository {

  // Future<List<Drug>> fetchDrugs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  //   final file = File(
  //       '${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');
  //
  //   if (await file.exists()) {
  //     final jsonData = await file.readAsString();
  //     return (json.decode(jsonData) as List)
  //         .map((item) => Drug.fromJson(item))
  //         .toList();
  //   } else {
  //     if (isFirstTime) {
  //       final response = await http.get(Uri.parse(
  //           'https://drive.google.com/uc?export=download&id=1kGZWVeMAPdqRhWWsrvqPg1lYUUm7TnHz'));
  //
  //       if (response.statusCode == 200) {
  //         await file.writeAsString(response.body);
  //         return (json.decode(response.body) as List)
  //             .map((item) => Drug.fromJson(item))
  //             .toList();
  //       } else {
  //         throw Exception('Failed to load data');
  //       }
  //     }
  //   }
  //   return [];
  // }

  Future<void> downloadData() async {
    //git show Burmese font correctly
     String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/drugs_data.json';

     //googleDrive link is not show Burmese font Correctly
    //String googleDriveLink = 'https://drive.google.com/uc?export=download&id=1kGZWVeMAPdqRhWWsrvqPg1lYUUm7TnHz';

    final response = await http.get(
    //  Uri.parse(googleDriveLink),
      Uri.parse(githubRawUrl),
    );

    if (response.statusCode == 200) {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/drugs_data.json');
      await file.writeAsString(response.body);
    } else {
      throw Exception('Failed to load data');

    }
  }
}
