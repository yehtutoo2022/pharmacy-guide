import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/drug_model.dart';
import '../data/hitory_provider.dart';
import 'drugs_detail.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});


  void _clearAllHistory(BuildContext context) {
    // Show confirmation dialog before clearing all history items
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All History'),
          content: Text('Are you sure you want to clear all history items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to clear all history items
                Provider.of<HistoryProvider>(context, listen: false).clearAllHistory();
                Navigator.of(context).pop();
              },
              child: Text('Clear All'),
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
        title: Text('History'),
        actions: [
          TextButton(
            onPressed: () => _clearAllHistory(context),
            child: Text(
              'Clear All',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, _) {
          final List<Drug> history = historyProvider.history;

          if (history.isEmpty) {
            return Center(
              child: Text('No drugs viewed yet.'),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final drug = history[index];
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(drug.name),
                    ),
                    IconButton(
                      icon: Icon(Icons.auto_delete_outlined),
                      onPressed: () {
                        historyProvider.removeFromHistory(drug);
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
