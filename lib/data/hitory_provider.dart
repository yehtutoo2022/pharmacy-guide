import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/drug_model.dart';

class HistoryProvider with ChangeNotifier {
  List<Drug> _history = [];
  late SharedPreferences _prefs;
  static const String _historyKey = 'history';

  List<Drug> get history => _history;

  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _prefs = await SharedPreferences.getInstance();
    final String? historyJson = _prefs.getString(_historyKey);
    if (historyJson != null) {
      List<dynamic> historyList = jsonDecode(historyJson);
      _history = historyList.map((json) => Drug.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveHistory() async {
    List<String> historyJsonList =
    _history.map((drug) => jsonEncode(drug.toJson())).toList();
    await _prefs.setStringList(_historyKey, historyJsonList);
  }

  void addToHistory(Drug drug) {
    // Check if the drug is already in the history
    if (!_history.contains(drug)) {
      // Add the drug to the history list
      _history.add(drug);
      _saveHistory(); // Save the updated history
      notifyListeners();
    }
  }

  void removeFromHistory(Drug drug) {
    // Remove the drug from the history list
    _history.remove(drug);
    _saveHistory(); // Save the updated history
    notifyListeners();
  }

  void clearAllHistory() {
    _history.clear(); // Remove all drugs from the history list
    _saveHistory(); // Save the updated history
    notifyListeners(); // Notify listeners about the change
  }
}
