import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drug_model.dart';

class FavoriteDrugProvider with ChangeNotifier {
  List<Drug> _favoriteDrugs = [];
  SharedPreferences? _prefs;

  FavoriteDrugProvider() {
    _loadFavoriteDrugs();
  }

  List<Drug> get favoriteDrugs => _favoriteDrugs;

  void toggleFavorite(Drug drug) {
    if (_favoriteDrugs.contains(drug)) {
      _favoriteDrugs.remove(drug);
    } else {
      // Check if the drug is already in the favorite drugs list
      if (!_favoriteDrugs.contains(drug)) {
        _favoriteDrugs.add(drug); // Add the drug to the favorite drugs list
      }
    }
    _saveFavoriteDrugs();
    notifyListeners();
  }


  bool isDrugFavorite(Drug drug) {
    return _favoriteDrugs.contains(drug);
  }

  Future<void> _loadFavoriteDrugs() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteDrugsJson = _prefs?.getStringList('favoriteDrugs');
    if (favoriteDrugsJson != null) {
      _favoriteDrugs = favoriteDrugsJson.map((json) => Drug.fromJson(jsonDecode(json))).toList();
    }
  }

  void _saveFavoriteDrugs() {
    final List<String> favoriteDrugsJson = _favoriteDrugs.map((drug) => jsonEncode(drug.toJson())).toList();
    _prefs?.setStringList('favoriteDrugs', favoriteDrugsJson);
  }

  void clearAllFavorites() {
    _favoriteDrugs.clear(); // Remove all drugs from the list
    _saveFavoriteDrugs(); // Save the updated list to SharedPreferences
    notifyListeners(); // Notify listeners about the change
  }
}