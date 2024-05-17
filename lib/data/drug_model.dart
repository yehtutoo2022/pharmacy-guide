//model is important to maintain favorite status to provider and prevent duplicate
class Drug {
  final String name;
  final String type;
  final String ingredients;
  final String category;
  final String drugClass;
  final String indication;
  final String madeIn;
  final int price;

  Drug({
    required this.name,
    required this.type,
    required this.ingredients,
    required this.category,
    required this.drugClass,
    required this.indication,
    required this.madeIn,
    required this.price,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      name: json['Drug Name '] ?? "",
      type: json['Type '] ?? "",
      ingredients: json['Ingredients'] ?? "",
      category: json['Drug Category'] ?? "",
      drugClass: json['Class'] ?? "",
      indication: json['Indication'] ?? "",
      madeIn: json['Made In '] ?? "",
      price: json['Price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Drug Name ': name,
      'Type ': type,
      'Ingredients': ingredients,
      'Drug Category': category,
      'Class': drugClass,
      'Indication': indication,
      'Made In ': madeIn,
      'Price': price,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Drug &&
        other.name == name &&
        other.type == type &&
        other.ingredients == ingredients &&
        other.category == category &&
        other.drugClass == drugClass &&
        other.indication == indication &&
        other.madeIn == madeIn &&
        other.price == price;
  }

  @override
  int get hashCode {
    return Object.hash(
        name,
        type,
        ingredients,
        category,
        drugClass,
        indication,
        madeIn,
        price);
  }
}
