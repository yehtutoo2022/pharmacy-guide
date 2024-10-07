import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/drug_model.dart';

class DrugRepository {

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
