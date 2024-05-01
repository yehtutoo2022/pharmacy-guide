

class Drug {
  final String name;
  final String category;
  final String ingredients;
  final String type;
  final int price;

  Drug({
    required this.name,
    required this.category,
    required this.ingredients,
    required this.type,
    required this.price,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      name: json['Drugs Name'],
      category: json['Category'],
      ingredients: json['Ingredients'],
      type: json['Type'],
      price: json['Price'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'Drugs Name': name,
      'Category': category,
      'Ingredients': ingredients,
      'Type': type,
      'Price': price,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Drug &&
        other.name == name &&
        other.category == category &&
        other.ingredients == ingredients &&
        other.type == type &&
        other.price == price;
  }

  @override
  int get hashCode {
    return Object.hash(name, category, ingredients, type, price);
  }
}
