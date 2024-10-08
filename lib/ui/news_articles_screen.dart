import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<News> _allNews = []; // Store all news
  List<News> _filteredNews = []; // Store filtered news
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
          _allNews = cachedNewsList;
          _filteredNews = cachedNewsList; // Initialize filtered list with full data
          _isLoading = false;
        });
        return cachedNewsList;
      }
    } catch (e) {
      print('Error loading cached news: $e');
    }
    // If no cached data or an error occurs, fetch from the network
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
          _allNews = newsList;
          _filteredNews = newsList; // Update filtered list as well
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

  // Search functionality using a SearchDelegate
  void _showSearch() {
    showSearch(
      context: context,
      delegate: NewsSearchDelegate(_allNews),
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: _showSearch,
          ),
        ],
      ),
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
            return RefreshIndicator(
              onRefresh: _refreshNews,
              child: ListView.builder(
                itemCount: _filteredNews.length,
                itemBuilder: (context, index) {
                  final news = _filteredNews[index];
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
                                      NewsDetailScreen(news: news),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: news.imageUrl,
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/image_loading.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
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
                                  news.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewsDetailScreen(news: news),
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

// Custom SearchDelegate for searching news articles
class NewsSearchDelegate extends SearchDelegate {
  final List<News> allNews;

  NewsSearchDelegate(this.allNews);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<News> results = allNews
        .where((news) =>
    news.title.toLowerCase().contains(query.toLowerCase()) ||
        news.contentP1.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final news = results[index];
        return ListTile(
          title: Text(news.title),
          subtitle: Text(news.contentP1, maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(news: news),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<News> suggestions = allNews
        .where((news) =>
    news.title.toLowerCase().contains(query.toLowerCase()) ||
        news.contentP1.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final news = suggestions[index];
        return ListTile(
          title: Text(news.title),
          onTap: () {
            query = news.title;
            showResults(context);
          },
        );
      },
    );
  }
}
