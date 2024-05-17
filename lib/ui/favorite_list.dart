import 'package:flutter/material.dart';
import 'package:pharmacy_guide2/data/favorite_drug_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../data/drug_model.dart';
import 'drugs_detail.dart';

class FavoriteDrugListScreen extends StatefulWidget {
  const FavoriteDrugListScreen({super.key});

  @override
  State<FavoriteDrugListScreen> createState() => _FavoriteDrugListScreenState();
}

class _FavoriteDrugListScreenState extends State<FavoriteDrugListScreen> {
  bool _isInSelectionMode = false;
  Set<Drug> _selectedDrugs = Set();

  void _toggleSelection(Drug drug) {
    setState(() {
      if(_selectedDrugs.contains(drug)){
        _selectedDrugs.remove(drug);
        if(_selectedDrugs.isEmpty) {
          _isInSelectionMode = false;
        }
      } else {
        _selectedDrugs.add(drug);
        _isInSelectionMode = true;
      }
    });
  }
  void _clearAllSelected() {
    setState(() {
      _selectedDrugs.clear();
      _isInSelectionMode = false;
    });
  }
  void _deleteSelectedDrugs (BuildContext context) {
    // Vibrate for 100 milliseconds
    Vibration.vibrate(duration: 100);
    
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Selected Drugs'),
            content: const Text('Are you sure to delete the selected drugs'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Provider.of<FavoriteDrugProvider>(context, listen: false)
                    .deleteSelectedDrugs(_selectedDrugs);
                    _clearAllSelected();
                  },
                  child: const Text('Delete'),
              ),
            ],
          );
        }
    );
  }
  void _clearAllFavorite(BuildContext context) {
    // Vibrate for 100 milliseconds
    Vibration.vibrate(duration: 100);


    // Show confirmation dialog before remove all favorite items
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove All Favorite'),
          content: const Text('Are you sure you want to remove all favorite items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<FavoriteDrugProvider>(context, listen: false).clearAllFavorites();
                Navigator.of(context).pop();
              },
              child: const Text('Remove All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isInSelectionMode ? 'Selected ${_selectedDrugs.length}' : 'Favorite Drugs'),
        actions: _isInSelectionMode
        //in selection mode, it show delete icon and clear icon
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteSelectedDrugs(context),
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => _clearAllSelected(),
          ),
        ]
        //if not in selection mode, it show remove all
            : [
          TextButton(
            onPressed: () => _clearAllFavorite(context),
            child: const Text(
              'Remove All',
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(_isInSelectionMode ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () => setState(() => _isInSelectionMode = !_isInSelectionMode),
          ),
        ],
      ),
      body: Consumer<FavoriteDrugProvider>(
        builder: (context, favoriteDrugProvider, _) {
          final favoriteDrugs = favoriteDrugProvider.favoriteDrugs;
          if (favoriteDrugs.isEmpty) {
            return const Center(
              child: Text('No favorite drugs yet.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteDrugs.length,
            itemBuilder: (context, index) {
              final drug = favoriteDrugs[index];
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(drug.name),
                    ),
                    //if not in selection mode
                    // if (!_isInSelectionMode) // Show the IconButton only if not in selection mode
                    //   IconButton(
                    //     icon: Icon(Icons.auto_delete_outlined),
                    //     onPressed: () {
                    //       favoriteDrugProvider.toggleFavorite(drug);
                    //     },
                    //   ),
                    if (_isInSelectionMode) // Show the Checkbox only in selection mode
                      Checkbox(
                        value: _selectedDrugs.contains(drug),
                        onChanged: (_) => _toggleSelection(drug),
                      ),
                  ],
                ),
                // subtitle: Text('Ingredients: ${drug.ingredients}'),
                onTap: () {
                  if (_isInSelectionMode) {
                    _toggleSelection(drug);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrugDetailScreen(drug: drug),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
