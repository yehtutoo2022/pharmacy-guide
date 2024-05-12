import 'package:flutter/material.dart';
import 'package:pharmacy_guide2/setting/more.dart';
import 'package:pharmacy_guide2/ui/drugs_history.dart';
import 'package:pharmacy_guide2/ui/news_screen.dart';

import 'advance/drugs_list_filter.dart';

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
      const DrugsListFilter(),
      const HistoryScreen(),
      NewsScreen(),
      MoreScreen(),
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
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor:
            Colors.grey, // Color for unselected items (icon and label)
        selectedItemColor:
            Colors.blue[200], // Color for selected items (icon and label)
        backgroundColor: Colors.brown[100],
      ),
    );
  }
}
