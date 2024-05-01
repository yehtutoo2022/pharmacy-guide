import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drug_model.dart';

class FavoriteDrugProvider with ChangeNotifier {
  Set<Drug> _favoriteDrugs = {};
 // A Set in Dart only allows unique values, so duplicates won't be added automatically.
  SharedPreferences? _prefs;

  FavoriteDrugProvider() {
    _loadFavoriteDrugs();
  }

  List<Drug> get favoriteDrugs => _favoriteDrugs.toList();

  void toggleFavorite(Drug drug) {
    if (_favoriteDrugs.contains(drug)) {
      _favoriteDrugs.remove(drug);
    } else {
      _favoriteDrugs.add(drug);
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
      _favoriteDrugs = favoriteDrugsJson.map((json) => Drug.fromJson(jsonDecode(json))).toSet();
    }
  }

  void _saveFavoriteDrugs() {
    final List<String> favoriteDrugsJson = _favoriteDrugs.map((drug) => jsonEncode(drug.toJson())).toList();
    _prefs?.setStringList('favoriteDrugs', favoriteDrugsJson);
  }

  void clearAllFavorites() {
    _favoriteDrugs.clear();
    _saveFavoriteDrugs();
    notifyListeners();
  }
}
