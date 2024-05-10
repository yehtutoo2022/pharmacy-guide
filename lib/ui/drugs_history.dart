import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../data/drug_model.dart';
import '../data/hitory_provider.dart';
import 'drugs_detail.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isInSelectionMode = false;
  final Set<Drug> _selectedDrugs = Set();

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
            title: Text('Delete Selected Drugs'),
            content: Text('Are you sure to delete the selected drugs'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Provider.of<HistoryProvider>(context, listen: false)
                      .deleteSelectedDrugs(_selectedDrugs);
                  _clearAllSelected();
                },
                child: Text('Delete'),
              ),
            ],
          );
        }
    );
  }


  void _clearAllHistory(BuildContext context) {
    Vibration.vibrate(duration: 100);
    // Show confirmation dialog before clearing all history items
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All History'),
          content: const Text('Are you sure you want to clear all history items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to clear all history items
                Provider.of<HistoryProvider>(context, listen: false).clearAllHistory();
                Navigator.of(context).pop();
              },
              child: const Text('Clear All'),
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
        title: Text(_isInSelectionMode ? 'Selected ${_selectedDrugs.length}' : 'History'),
        actions: _isInSelectionMode
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteSelectedDrugs(context),
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => _clearAllSelected(),
          ),
        ]
            : [
          TextButton(
            onPressed: () => _clearAllHistory(context),
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
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, _) {
          final List<Drug> history = historyProvider.history;

          if (history.isEmpty) {
            return const Center(
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
                    if(_isInSelectionMode)
                      Checkbox(
                          value: _selectedDrugs.contains(drug),
                          onChanged: (_) => _toggleSelection(drug) ),
                  ],
                ),
                subtitle: Text('Category: ${drug.category}'),
                onTap: () {
                  if(_isInSelectionMode) {
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
