import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_guide2/setting/theme.dart';
import 'package:pharmacy_guide2/setting/update_data_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Update Database'),
            onTap: () {
              // Navigate to theme settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateDataScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Theme'),
            onTap: () {
              // Navigate to theme settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeSettingsScreen()),
              );
            },
          ),

          ListTile(
            title: const Text('About App'),
            onTap: () {
              // Navigate to language settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
          // Add more settings options here...
        ],
      ),
    );
  }
}


class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: FutureBuilder(
        future: _loadAboutText(), // Load the text file content
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    snapshot.data.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Display a loading indicator while data is being fetched
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Function to load the content of the text file
  Future<String> _loadAboutText() async {
    return await rootBundle.loadString('assets/about_app.txt');
  }
}


// Example "Terms of Service" screen
class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const Center(
        child: Text('Terms of Service'),
      ),
    );
  }
}

// Example "Privacy Policy" screen
class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Center(
        child: Text('Privacy Policy'),
      ),
    );
  }
}
