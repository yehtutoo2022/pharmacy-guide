import 'package:flutter/material.dart';

import '../data/drug_model.dart';


class CategoryDrugsScreen extends StatelessWidget {
  final List<Drug> drugs; // List of drugs for the selected category
  final String category; // Selected category

  CategoryDrugsScreen({required this.drugs, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drugs - $category'),
      ),
      body: ListView.builder(
        itemCount: drugs.length,
        itemBuilder: (context, index) {
          final drug = drugs[index];
          return ListTile(
            title: Text(drug.name),
            subtitle: Text('Price: \$${drug.price.toString()}'),
            // Add more details or customize as needed
          );
        },
      ),
    );
  }
}
