import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../data/noti_model.dart';
import 'notification_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //adding future is to show loading indicator while fetching from internet

  late Future<List<Noti>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = loadNotifications();
  }

  Future<List<Noti>> loadNotifications() async {

    String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/noti_data.json';

    try {
      final response = await http.get(
          Uri.parse(githubRawUrl),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Noti.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error loading notifications: $e');
      throw e;
    }
  }

  Future<List<Noti>> loadNotificationsAssets() async {
    // path
    String assetPath = 'assets/noti_data.json';

    try {
      // Load JSON string from assets
      String jsonString = await rootBundle.loadString(assetPath);

      // Parse JSON string
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Convert JSON objects to Noti objects
      List<Noti> notifications = jsonList.map((e) => Noti.fromJson(e)).toList();

      return notifications;
    } catch (e) {
      print('Error loading notifications from assets: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      //FutureBuilder is to show loading indicator while fetching from internet
      body: FutureBuilder<List<Noti>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading Notifications...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Please check your internet connection'),
            );
          } else {
            List<Noti>? notifications = snapshot.data;
            return ListView.builder(
              itemCount: notifications?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(
                      notifications![index].notiTitle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      notifications[index].notiContent,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Image.network(
                      notifications[index].imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationDetailScreen(notification: notifications[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}
