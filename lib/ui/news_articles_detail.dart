import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../data/bookmark_provider.dart';
import '../data/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;

  NewsDetailScreen({required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late BookmarkProvider bookmarkProvider;
  bool isBookmark = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
      isBookmark = bookmarkProvider.isBookmark(widget.news);

    });
  }

  void toggleBookmark() {
    Vibration.vibrate(duration: 100);

    setState(() {
      isBookmark = !isBookmark;
    });
    bookmarkProvider.toggleBookmark(widget.news);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isBookmark ? 'Added to bookmark' : 'Remove from bookmark'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news.title),
        backgroundColor: Colors.blue[800],
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, _) {
              bool isBookmark = bookmarkProvider.isBookmark(widget.news);
              return IconButton(
                icon: Icon(
                  isBookmark ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmark ? Colors.red : null,
                ),
                onPressed: toggleBookmark,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9, // You can adjust the aspect ratio as needed
              child: Image.network(
                widget.news.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                widget.news.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Source: ${widget.news.source}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.news.contentP1,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.news.contentP2,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.news.contentP3,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.news.contentP4,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.news.contentP5,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
