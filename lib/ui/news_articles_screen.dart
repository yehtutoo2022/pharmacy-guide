import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_guide2/data/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookmark_screen.dart';
import 'news_articles_detail.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  late Future<List<News>> _news;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _news = _loadCachedNews();
  }

  Future<List<News>> _loadCachedNews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedNews = prefs.getString('cached_news');

      if (cachedNews != null) {
        List<dynamic> jsonList = jsonDecode(cachedNews);
        List<News> cachedNewsList = jsonList.map((e) => News.fromJson(e)).toList();
        setState(() {
          _isLoading = false;
        });
        return cachedNewsList;
      }
    } catch (e) {
      print('Error loading cached notifications: $e');
    }
    // If cached data not found or error occurred, fetch it from the network
    return _fetchNews();
  }

  Future<List<News>> _fetchNews() async {
    try {
      String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/news_data.json';
      final response = await http.get(Uri.parse(githubRawUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<News> newsList = jsonList.map((e) => News.fromJson(e)).toList();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_news', jsonEncode(jsonList));

        setState(() {
          _isLoading = false;
        });
        return newsList;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error loading news: $e');
      setState(() {
        _isLoading = false;
      });
      return [];
    }
  }

  Future<void> _refreshNews() async {
    setState(() {
      _news = _fetchNews();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Articles',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.bookmark, color: Colors.white),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const BookmarkScreen(),
        //         ),
        //       );
        //     },
        //   ),
        // ],
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
                  Text('Loading Articles...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Please check your internet connection'),
            );
          } else {
            List<News>? news = snapshot.data;
            return RefreshIndicator(
              onRefresh: _refreshNews,
              child: ListView.builder(
                itemCount: news?.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Card(
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
                            // child: ClipRRect(
                            //   borderRadius: BorderRadius.circular(8),
                            //   child: Image.network(
                            //   //  placeholder: 'assets/images/image_loading.png', // Your placeholder image asset path
                            //     news![index].imageUrl,
                            //     fit: BoxFit.cover,
                            //     width: double.infinity,
                            //     height: 200, // Adjust this height as needed
                            //   ),
                            // ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: news![index].imageUrl,
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/image_loading.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.red,),
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
                                  news[index].title,
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
                    ),
                  );
              
                },
              ),
            );

          }
        },
      ),
    );
  }
}