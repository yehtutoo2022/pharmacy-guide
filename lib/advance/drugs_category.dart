import 'package:flutter/material.dart';

import '../data/drug_model.dart';
import 'drugs_category_list.dart';

class DrugCategoriesScreen extends StatelessWidget {
  final List<Drug> drugs; // List of all drugs

  DrugCategoriesScreen({required this.drugs});

  @override
  Widget build(BuildContext context) {
    // Extract all unique drug categories
    Set<String> categories = Set();
    drugs.forEach((drug) {
      categories.add(drug.category);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Drug Categories'),
      ),
      body: ListView(
        children: categories.map((category) {
          return ListTile(
            title: Text(category),
            onTap: () {
              // Navigate to the screen showing drugs related to this category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDrugsScreen(
                    drugs: drugs
                        .where((drug) => drug.category == category)
                        .toList(),
                    category: category,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
