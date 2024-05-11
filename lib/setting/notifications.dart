import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/noti_model.dart';
import 'notification_detail.dart';

// class NotificationScreen extends StatefulWidget {
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//  // List<Noti> notifications = [];
//   Future<List<Noti>> _notificationFuture;
//   @override
//   void initState() {
//     super.initState();
//   //  loadNotifications();
//     _notificationFuture = loadNotifications();
//   }
//
//   // Future<void> loadNotifications() async {
//   //
//   //   String googleDriveLink = 'https://drive.google.com/uc?id=1D5ObejHN3g1I0ORk3WgrO2cRzJ_dD4qM';
//   //
//   //   try {
//   //     // Make HTTP GET request to fetch the file contents
//   //     final response = await http.get(Uri.parse(googleDriveLink));
//   //
//   //     // Check if the request was successful
//   //     if (response.statusCode == 200) {
//   //       // Parse JSON data
//   //       List<dynamic> jsonList = jsonDecode(response.body);
//   //
//   //       setState(() {
//   //         // Create Noti objects from JSON data
//   //         notifications = jsonList.map((e) => Noti.fromJson(e)).toList();
//   //       });
//   //     } else {
//   //       // Handle error if request fails
//   //       throw Exception('Failed to load notifications');
//   //     }
//   //   } catch (e) {
//   //     // Handle exception
//   //     print('Error loading notifications: $e');
//   //   }
//   // }
//
//   Future<List<Noti>> loadNotifications() async {
//     String googleDriveLink = 'https://drive.google.com/uc?id=1D5ObejHN3g1I0ORk3WgrO2cRzJ_dD4qM';
//
//     try {
//       final response = await http.get(Uri.parse(googleDriveLink));
//
//       if (response.statusCode == 200) {
//         List<dynamic> jsonList = jsonDecode(response.body);
//         return jsonList.map((e) => Noti.fromJson(e)).toList();
//       } else {
//         throw Exception('Failed to load notifications');
//       }
//     } catch (e) {
//       print('Error loading notifications: $e');
//       throw e;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: ListView.builder(
//         //itemCount: notifications.length,
//
//
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(notifications[index].notiTitle),
//             subtitle: Text(notifications[index].notiContent),
//             leading: Image.network(notifications[index].imageUrl),
//               onTap: () {
//                 // Navigate to detail screen when a notification is clicked
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NotificationDetailScreen(notification: notifications[index]),
//                   ),
//                 );
//               }
//           );
//         },
//       ),
//     );
//   }
// }

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
   // _notifications = loadNotificationsAssets();
  }

  Future<List<Noti>> loadNotifications() async {
    //you can replace with other Google Drive link
    String googleDriveLink = 'https://drive.google.com/uc?id=1D5ObejHN3g1I0ORk3WgrO2cRzJ_dD4qM';

    try {
      final response = await http.get(
          Uri.parse(googleDriveLink),
        headers: {
          'Accept-Charset': 'utf-8', // Specify UTF-8 charset
        },
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
              child: Text('No internet connection or weak internet connection'),
            );
          } else {
            List<Noti>? notifications = snapshot.data;
            return ListView.builder(
              itemCount: notifications?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications![index].notiTitle),
                  subtitle: Text(notifications[index].notiContent),
                  leading: Image.network(notifications[index].imageUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailScreen(notification: notifications![index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
