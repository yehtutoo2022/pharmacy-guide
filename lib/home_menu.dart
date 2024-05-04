import 'package:flutter/material.dart';
import 'package:pharmacy_guide2/test/drugs_list_filter.dart';
import 'package:pharmacy_guide2/ui/drugs_history.dart';
import 'package:pharmacy_guide2/ui/drugs_list.dart';
import 'package:pharmacy_guide2/ui/favorite_list.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;


  @override
  void initState() {
    super.initState();
    _screens = [
      DrugsListScreen(),
      const FavoriteDrugListScreen(),
      const HistoryScreen(),
      const DrugsListFilter(),

    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Tool',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor:
            Colors.grey, // Color for unselected items (icon and label)
        selectedItemColor:
            Colors.red, // Color for selected items (icon and label)
        backgroundColor: Colors.brown[100],
      ),
    );
  }
}
