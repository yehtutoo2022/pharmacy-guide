
class Drug {
  final String name;
  final String type;
  final String ingredients;
  final String category;
  final String drugClass;
  final String indication;
  final String sideEffects;
  final String directionUse;
  final String sellingUnit;
  final String manufacture;
  final String madeIn;
  final int price;

  Drug({
    required this.name,
    required this.type,
    required this.ingredients,
    required this.category,
    required this.drugClass,
    required this.indication,
    required this.sideEffects,
    required this.directionUse,
    required this.sellingUnit,
    required this.manufacture,
    required this.madeIn,
    required this.price,
  });

  // Factory constructor to parse JSON data into Drug model
  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      name: json['Drug Name'] ?? "",
      type: json['Type'] ?? "",
      ingredients: json['Ingredients'] ?? "",
      category: json['Drug Category'] ?? "",
      drugClass: json['Class'] ?? "",
      indication: json['Indication'] ?? "",
      sideEffects: json['Side Effects'] ?? "",
      directionUse: json['Direction of use'] ?? "",
      sellingUnit: json['Selling Unit'] ?? "",
      manufacture: json['Manufacture'] ?? "",
      madeIn: json['Made In'] ?? "",
      // Handle price conversion from string to int (remove commas)
      price: int.tryParse(json['Price'].replaceAll(",", "")) ?? 0,
    );
  }

  // Convert Drug object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'Drug Name': name,
      'Type': type,
      'Ingredients': ingredients,
      'Drug Category': category,
      'Class': drugClass,
      'Indication': indication,
      'Side Effects': sideEffects,
      'Direction of use': directionUse,
      'Selling Unit': sellingUnit,
      'Manufacture': manufacture,
      'Made In': madeIn,
      'Price': price,
    };
  }

  // Equality operator override to prevent duplicates
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
        other.sideEffects == sideEffects &&
        other.directionUse == directionUse &&
        other.sellingUnit == sellingUnit &&
        other.manufacture == manufacture &&
        other.madeIn == madeIn &&
        other.price == price;
  }

  // Override hashCode for efficient lookups
  @override
  int get hashCode {
    return Object.hash(
        name,
        type,
        ingredients,
        category,
        drugClass,
        indication,
        sideEffects,
        directionUse,
        sellingUnit,
        manufacture,
        madeIn,
        price
    );
  }
}
