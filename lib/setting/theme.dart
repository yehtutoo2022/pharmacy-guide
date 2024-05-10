import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ThemeSettingsScreen extends StatefulWidget {
  @override
  _ThemeSettingsScreenState createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late bool _isDarkMode;


  @override
  void initState() {
    super.initState();
    _loadThemeMode(); // Load theme mode when the screen is initialized
  }
  // Method to load theme mode from SharedPreferences
  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Set _isDarkMode to the saved theme mode value, defaulting to false (light mode)
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }
  // Method to save theme mode to SharedPreferences
  void _saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
                _saveThemeMode(_isDarkMode); // Save theme mode to SharedPreferences
                MyApp.setTheme(context, _isDarkMode ? ThemeData.dark() : ThemeData.light());
              });
            },
          ),
        ],
      ),
    );
  }
}