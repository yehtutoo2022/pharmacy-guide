import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drug_model.dart';

//chat GPT is not useful for complex error solving
//I found error in saving drug history with provider, it show favorite drug provider
//But, it cannot write correctly based on favorite drug provider
//So, I copy favorite drug provider and rename to history provider and other related methods
//Finally, I solved my problem
//chat GPT could not

class HistoryProvider with ChangeNotifier {
  Set<Drug> _history = {};
  // A Set in Dart only allows unique values, so duplicates won't be added automatically.
  SharedPreferences? _prefs;

  HistoryProvider() {
    _loadHistory();
  }

  List<Drug> get history => _history.toList();


    Future<void> addToHistory(Drug drug) async {
    if (!_history.contains(drug)) {
      _history.add(drug);
      await _saveHistory();
      notifyListeners();
    }
  }

  bool isHistory(Drug drug) {
    return _history.contains(drug);
  }

  Future<void> _loadHistory() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? historyJson = _prefs?.getStringList('history');
    if (historyJson != null) {
      _history = historyJson.map((json) => Drug.fromJson(jsonDecode(json))).toSet();
    }
  }

  Future<void> _saveHistory() async {
    final List<String> historyJson = _history.map((drug) => jsonEncode(drug.toJson())).toList();
    await _prefs?.setStringList('history', historyJson);
  }

  void removeFromHistory(Drug drug) {
    _history.remove(drug);
    _saveHistory();
    notifyListeners();
  }

  void clearAllHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  void deleteSelectedDrugs (Set<Drug> drugs) {
    _history.removeAll(drugs);
    _saveHistory();
    notifyListeners();
  }
}
