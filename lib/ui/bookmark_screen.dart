import 'package:flutter/material.dart';
import 'package:pharmacy_guide2/data/news_model.dart';
import 'package:provider/provider.dart';

import '../data/bookmark_provider.dart';
import 'news_articles_detail.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<News> bookmarkedNews = Provider.of<BookmarkProvider>(context).bookmark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Bookmarks',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: bookmarkedNews.isEmpty
          ? const Center(
        child: Text('No bookmarks yet.'),
      )
          : ListView.builder(
        itemCount: bookmarkedNews.length,
        itemBuilder: (context, index) {
          final News news = bookmarkedNews[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.source),
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
      ),
    );
  }
}
