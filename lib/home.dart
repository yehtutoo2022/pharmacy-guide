import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_guide2/drug/drugs_history.dart';
import 'package:pharmacy_guide2/drug/drugs_list_filter.dart';
import 'package:pharmacy_guide2/ui/favorite_list.dart';
import 'package:pharmacy_guide2/ui/news_articles_detail.dart';
import 'package:pharmacy_guide2/data/news_model.dart'; // Assuming this is your news model
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pharmacy_guide2/ui/news_articles_screen.dart';

import 'data/quote_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<News> _newsList = [];
  bool _isLoading = true;
  String _quote = "Fetching quote...";
  String _author = "";

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _fetchHealthQuote(); // Fetch health-related quote on initialization
  }

  Future<void> _fetchHealthQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/quotes?category=happiness'),
        headers: {
          'X-Api-Key': 'WDCavCIQfCLcV8miGAsP/w==OmtBHa5E5528RmMi', // Replace with your actual API key
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Check if the response is not empty
        if (jsonResponse.isNotEmpty) {
          final quoteData = jsonResponse[0];
          setState(() {
            Quote quote = Quote.fromJson(quoteData); // Create Quote instance
            _quote = quote.quote; // Get the quote from the model
            _author = quote.author; // Get the author from the model
          });
        } else {
          setState(() {
            _quote = "No quote found.";
            _author = "";
          });
        }
      } else {
        setState(() {
          _quote = "Error: ${response.statusCode}";
          _author = "";
        });
      }
    } catch (e) {
      setState(() {
       // _quote = "Failed to fetch quote: $e";
        _quote = "Internet connection error";
        _author = "";
      });
      print("Error fetching quote: $e");
    }
  }

  Future<void> _fetchNews() async {
    try {
      String githubRawUrl = 'https://raw.githubusercontent.com/yehtutoo2022/pharmacy-guide/master/assets/news_data.json';
      final response = await http.get(Uri.parse(githubRawUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<News> newsList = jsonList.map((e) => News.fromJson(e)).toList();

        setState(() {
          _newsList = newsList;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, yyyy').format(DateTime.now()); // Get today's date
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        title: Row(
          children: [
            // Logo Image
            Image.asset(
              'assets/images/mm_pharmacy_guide_logo.png',
              height: 40, // Set height of the logo
            ),
            const SizedBox(width: 8), // Spacing between logo and title
            const Text(
              'Home',
              style: TextStyle(
                color: Colors.white, // Set text color to black
              ),
            ),
          ],
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote of the Day Section
              SizedBox(
                width: double.infinity, // Make the container fill the screen width
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today Quote: $todayDate',  // Add today's date here
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"$_quote"',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '- $_author',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add spacing after the image
              // Add your asset image here with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                child: Image.asset(
                  'assets/images/ypharmacy_home.png', // Update with your image path
                  height: 250, // Set desired height
                  width: double.infinity, // Makes the image full-width
                  fit: BoxFit.cover, // Adjust image fit
                ),
              ),

              const SizedBox(height: 16),
              // Categories Grid wrapped in a Card
              Card(
                elevation: 4, // Add elevation to give the card a shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners for the card
                ),
                margin: const EdgeInsets.all(8), // Add margin around the card for spacing
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Add padding inside the card
                  child: Center(
                    child: GridView.count(
                      shrinkWrap: true, // Ensures the grid does not take up infinite space
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildCategoryItem('Drugs', Icons.category, Colors.purple, context),
                        _buildCategoryItem('Articles', Icons.newspaper, Colors.teal, context),
                        _buildCategoryItem('History', Icons.history, Colors.orange, context),
                        _buildCategoryItem('Favorite', Icons.favorite, Colors.red, context),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add spacing after the image
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Articles.....',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              // Animated News List
              _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loader while news is fetching
                  : Container(
                height: 150, // Set height for the news list section
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                 // itemCount: _newsList.length,
                  itemCount: _newsList.length > 5 ? 5 : _newsList.length, // Limit to 5 items
                  itemBuilder: (context, index) {
                    final news = _newsList[index];
                    return _buildAnimatedNewsCard(news, index);
                  },
                ),
              ),
              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }

  // Build the animated news card
  Widget _buildAnimatedNewsCard(News news, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: AnimatedOpacity(
        opacity: 1.0,
       // duration: Duration(milliseconds: 500 + index * 100), // Delay the animation based on index
        duration: const Duration(milliseconds: 1000), // Updated to 1 second

        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news)),
            );
          },
          child: Container(
            width: 200, // Fixed width for the news card
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    news.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    news.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the category items (same as before)
  Widget _buildCategoryItem(String title, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Drugs') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DrugsListFilter()),
          );
        } else if (title == 'Articles') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsScreen()),
          );
        } else if (title == 'History') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        } else if (title == 'Favorite') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteDrugListScreen()),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

