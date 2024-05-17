import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'news_model.dart';

class BookmarkProvider with ChangeNotifier {
  Set<News> _bookmark = {};
  SharedPreferences? _prefs;

  BookmarkProvider() {
    _loadBookmark();
  }

  List<News> get bookmark => _bookmark.toList();

  void toggleBookmark(News news) {
    if (_bookmark.contains(news)) {
      _bookmark.remove(news);
    } else {
      _bookmark.add(news);
    }
    _saveBookmark();
    notifyListeners();
  }

  bool isBookmark(News news) {
    return _bookmark.contains(news);
  }

  Future<void> _loadBookmark() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkJson = _prefs?.getStringList('bookmark');
    if (bookmarkJson != null) {
      _bookmark = bookmarkJson.map((json) => News.fromJson(jsonDecode(json))).toSet();
    }
  }

  void _saveBookmark() {
    final List<String> bookmarkJson = _bookmark.map((drug) => jsonEncode(drug.toJson())).toList();
    _prefs?.setStringList('bookmark', bookmarkJson);
  }

  void clearAllBookmark() {
    _bookmark.clear();
    _saveBookmark();
    notifyListeners();
  }

  void deleteSelectedBookmark (Set<News> news) {
    _bookmark.removeAll(news);
    _saveBookmark();
    notifyListeners();
  }
}
