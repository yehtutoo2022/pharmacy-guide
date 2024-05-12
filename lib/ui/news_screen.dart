import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_guide2/data/news_model.dart';
import 'news_detail.dart';


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {


  late Future<List<News>> _news;

  @override
  void initState() {
    super.initState();
    _news = loadNews();
  }

  Future<List<News>> loadNews() async {
    String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/news_data.json';

    try {
      final response = await http.get(
        Uri.parse(githubRawUrl),

      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => News.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error loading news: $e');
      throw e;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      //FutureBuilder is to show loading indicator while fetching from internet
      body: FutureBuilder<List<News>>(
        future: _news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading News...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Please check your internet connection'),
            );
          } else {
            List<News>? news = snapshot.data;
            return ListView.builder(
              itemCount: news?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(news: news[index]),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            news![index].imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200, // Adjust this height as needed
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 200), // Spacer to push content below the image
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              news![index].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text(
                            //   news[index].contentP1,
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetailScreen(news: news[index]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
