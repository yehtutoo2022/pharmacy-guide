//model is important to maintain favorite status to provider and prevent duplicate
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

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      name: json['Drug Name '] ?? "",
      type: json['Type '] ?? "",
      ingredients: json['Ingredients'] ?? "",
      category: json['Drug Category'] ?? "",
      drugClass: json['Class'] ?? "",
      indication: json['Indication'] ?? "",
      sideEffects: json['Side Effects'] ?? "",
      directionUse: json['Direction of Use'] ?? "",
      sellingUnit: json['Selling Unit'] ?? "",
      manufacture: json['Manufacture'] ?? "",
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
      'Side Effects': sideEffects,
      'Direction of Use': directionUse,
      'Selling Unit': sellingUnit,
      'Manufacture': manufacture,
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
        other.sideEffects == sideEffects &&
        other.directionUse == directionUse &&
        other.sellingUnit == sellingUnit &&
        other.manufacture == manufacture &&
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
        sideEffects,
        directionUse,
        sellingUnit,
        manufacture,
        madeIn,
        price);
  }
}
