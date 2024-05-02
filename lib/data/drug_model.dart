//
//
// class Drug {
//   final String name;
//   final String category;
//   final String ingredients;
//   final String type;
//   final int price;
//
//   Drug({
//     required this.name,
//     required this.category,
//     required this.ingredients,
//     required this.type,
//     required this.price,
//   });
//
//   factory Drug.fromJson(Map<String, dynamic> json) {
//     return Drug(
//       name: json['Drugs Name'],
//       category: json['Category'],
//       ingredients: json['Ingredients'],
//       type: json['Type'],
//       price: json['Price'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Drugs Name': name,
//       'Category': category,
//       'Ingredients': ingredients,
//       'Type': type,
//       'Price': price,
//     };
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other.runtimeType != runtimeType) return false;
//     return other is Drug &&
//         other.name == name &&
//         other.category == category &&
//         other.ingredients == ingredients &&
//         other.type == type &&
//         other.price == price;
//   }
//
//   @override
//   int get hashCode {
//     return Object.hash(name, category, ingredients, type, price);
//   }
// }

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
    return Object.hash(name, type, ingredients, category, drugClass, indication, madeIn, price);
  }
}
