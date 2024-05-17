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
  late Future<List<Noti>> _noti;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _noti = _loadCachedNoti();
  }

  Future<List<Noti>> _loadCachedNoti() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedNoti = prefs.getString('cached_noti');

      if (cachedNoti != null) {
        List<dynamic> jsonList = jsonDecode(cachedNoti);
        List<Noti> cachedNotiList = jsonList.map((e) => Noti.fromJson(e)).toList();
        setState(() {
          _isLoading = false;
        });
        return cachedNotiList;
      }
    } catch (e) {
      print('Error loading cached notifications: $e');
    }
    // If cached data not found or error occurred, fetch it from the network
    return _fetchNoti();
  }

  Future<List<Noti>> _fetchNoti() async {
    try {
      String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/noti_data.json';
      final response = await http.get(Uri.parse(githubRawUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Noti> notiList = jsonList.map((e) => Noti.fromJson(e)).toList();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_noti', jsonEncode(jsonList));

        setState(() {
          _isLoading = false;
        });
        return notiList;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Noti>>(
        future: _noti,
        builder: (context, snapshot) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No notifications available'),
            );
          } else {
            List<Noti>? notifications = snapshot.data;
            return ListView.builder(
              itemCount: notifications!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      notifications[index].notiTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    trailing: const Icon(Icons.arrow_forward_ios),
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
