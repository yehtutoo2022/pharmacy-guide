class News {
  final String category;
  final String source;
  final String title;
  final String contentP1;
  final String contentP2;
  final String contentP3;
  final String contentP4;
  final String contentP5;
  final String imageUrl;

  News({
    required this.category,
    required this.source,
    required this.title,
    required this.contentP1,
    required this.contentP2,
    required this.contentP3,
    required this.contentP4,
    required this.contentP5,
    required this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      category: json['Category'],
      source: json['Source'],
      title: json['Title'],
      contentP1: json['Content_P1'],
      contentP2: json['Content_P2'],
      contentP3: json['Content_P3'],
      contentP4: json['Content_P4'],
      contentP5: json['Content_P5'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Category': category,
      'Source': source,
      'Title': title,
      'Content_P1': contentP1,
      'Content_P2': contentP2,
      'Content_P3': contentP3,
      'Content_P4': contentP4,
      'Content_P5': contentP5,
      'ImageUrl': imageUrl,
    };
  }
}
