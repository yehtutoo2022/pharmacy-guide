import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_guide2/setting/theme.dart';
import 'package:pharmacy_guide2/setting/update_data_screen.dart';
import 'package:pharmacy_guide2/ui/favorite_list.dart';
import 'notifications.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.notifications,color: Colors.blue[200]),
            title: const Text('Notifications'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite,color: Colors.blue[200]),
            title: const Text('Favorites'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteDrugListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.backup_sharp,color: Colors.blue[200]),
            title: const Text('Update Database'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateDataScreen()),
              );
            },
          ),

          const SizedBox(height: 16), // Add space before the next ListTile
          const ListTile(
            title: Text('Settings',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.local_florist_rounded,color: Colors.blue[200]),
            title: const Text('Theme'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeSettingsScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.facebook,color: Colors.blue[200]),
            title: const Text('About App'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/mm_pharmacy_guide_logo.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      snapshot.data.toString(),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
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
