// quote_model.dart

class Quote {
  final String quote;
  final String author;
  final String category;

  Quote({
    required this.quote,
    required this.author,
    required this.category,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
    );
  }
}
