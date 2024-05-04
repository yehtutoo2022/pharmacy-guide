import 'package:flutter/material.dart';
import 'package:pharmacy_guide2/data/favorite_drug_provider.dart';
import 'package:provider/provider.dart';
import 'drugs_detail.dart';

class FavoriteDrugListScreen extends StatelessWidget {
  const FavoriteDrugListScreen({super.key});


  void _clearAllFavorite(BuildContext context) {
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
        title: const Text('Favorite Drugs'),
        actions: [
          TextButton(
            onPressed: () => _clearAllFavorite(context),
            child: const Text(
              'Remove All',
              style: TextStyle(color: Colors.black),
            ),
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
                    IconButton(
                      icon: const Icon(Icons.auto_delete_outlined),
                      onPressed: () {
                        favoriteDrugProvider.toggleFavorite(drug);
                      },
                    ),
                  ],
                ),
                subtitle: Text('Category: ${drug.category}'),
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
          );
        },
      ),
    );
  }
}
