import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/favorite_drug_provider.dart';
import 'drugs_detail.dart';

class FavoriteDrugListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteDrugProvider = Provider.of<FavoriteDrugProvider>(context);
    final favoriteDrugs = favoriteDrugProvider.favoriteDrugs;

    void _showClearAllConfirmationDialog(BuildContext context, FavoriteDrugProvider favoriteDrugProvider) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Clear All'),
            content: Text('Are you sure you want to clear all favorite drugs?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Clear All'),
                onPressed: () {
                  favoriteDrugProvider.clearAllFavorites();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Drugs'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showClearAllConfirmationDialog(context, favoriteDrugProvider);
            },
          ),
        ],
      ),
      body: favoriteDrugs.isEmpty
          ? Center(
        child: Text('No favorite drugs.'),
      )
          : ListView.builder(
        itemCount: favoriteDrugs.length,
        itemBuilder: (context, index) {
          final drug = favoriteDrugs[index];
          return ListTile(
            title: Text(drug.name),
            subtitle: Text('Category: ${drug.category}'),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                // Remove the drug from favorites when the icon button is pressed
                favoriteDrugProvider.toggleFavorite(drug);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrugDetailScreen(drug: drug),
                ),
              );
            },
          );
        },
      ),
    );
  }
}