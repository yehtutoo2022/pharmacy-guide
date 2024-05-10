import 'package:flutter/material.dart';
import 'package:pharmacy_guide2/repository/drug_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class UpdateDataScreen extends StatefulWidget {
  @override
  _UpdateDataScreenState createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  final DrugRepository _repository = DrugRepository();
  bool _updating = false;
  String _lastUpdatedDate = '';

  @override
  void initState() {
    super.initState();
    _loadLastUpdatedDate();
  }

  Future<void> _loadLastUpdatedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastUpdatedDate = prefs.getString('lastUpdatedDate') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Last Updated: $_lastUpdatedDate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updating ? null : () => _updateData(context),
              child: const Text('Update Drugs Database'),
            ),
            if (_updating)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateData(BuildContext context) async {
    try {
      setState(() {
        _updating = true; // Show circular progress indicator
      });
      // Obtain current date
      String currentDate = DateTime.now().toString();

      // Saving current date
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastUpdatedDate', DateTime.now().toString());

      await prefs.setString('lastUpdatedDate', currentDate);

      setState(() {
        _lastUpdatedDate = currentDate; // Update last updated date in the UI
      });

      await _repository.downloadData();


      Vibration.vibrate(duration: 100);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Drugs Database Updated'),
            content: const Text('Drugs Database updated successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      _loadLastUpdatedDate(); // Reload last updated date
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Failed'),
            content: Text('Failed to update data: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _updating = false; // Hide circular progress indicator
      });
    }
  }

}
