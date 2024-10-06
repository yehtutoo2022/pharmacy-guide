import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../data/drug_model.dart';
import '../data/history_provider.dart';
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
      if (_selectedDrugs.contains(drug)) {
        _selectedDrugs.remove(drug);
        if (_selectedDrugs.isEmpty) {
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

  void _deleteSelectedDrugs(BuildContext context) {
    Vibration.vibrate(duration: 100);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.red[50],
            title: Text(
              'Delete Selected Drugs',
              style: TextStyle(color: Colors.red[900]),
            ),
            content: Text('Are you sure you want to delete the selected drugs?',
                style: TextStyle(color: Colors.red[700])),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.grey))),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<HistoryProvider>(context, listen: false)
                      .deleteSelectedDrugs(_selectedDrugs);
                  _clearAllSelected();
                },
                child: Text('Delete', style: TextStyle(color: Colors.red[900])),
              ),
            ],
          );
        });
  }

  void _clearAllHistory(BuildContext context) {
    Vibration.vibrate(duration: 100);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.blue[50],
          title: Text(
            'Clear All History',
            style: TextStyle(color: Colors.blue[900]),
          ),
          content: Text(
              'Are you sure you want to clear all history items?',
              style: TextStyle(color: Colors.blue[700])),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<HistoryProvider>(context, listen: false)
                    .clearAllHistory();
                Navigator.of(context).pop();
              },
              child: Text('Clear All', style: TextStyle(color: Colors.blue[900])),
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
        title: Text(
          _isInSelectionMode
              ? 'Selected ${_selectedDrugs.length}'
              : 'History',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        actions: _isInSelectionMode
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteSelectedDrugs(context),
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => _clearAllSelected(),
            color: Colors.white,
          ),
        ]
            : [
          TextButton(
            onPressed: () => _clearAllHistory(context),
            child: const Text(
              'Remove All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isInSelectionMode
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            onPressed: () =>
                setState(() => _isInSelectionMode = !_isInSelectionMode),
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

          final reversedHistory = history.reversed.toList();

          return ListView.separated(
            itemCount: reversedHistory.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.grey,
              );
            },
            itemBuilder: (context, index) {
              final drug = reversedHistory[index];

              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(drug.name),
                    ),
                    if (_isInSelectionMode)
                      Checkbox(
                          value: _selectedDrugs.contains(drug),
                          onChanged: (_) => _toggleSelection(drug)),
                  ],
                ),
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
