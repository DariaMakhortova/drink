enum DrinkCategory { matcha, coffee, tea, lemonade, seasonal }

extension DrinkCategoryX on DrinkCategory {
  String get label {
    switch (this) {
      case DrinkCategory.matcha:
        return 'Матча';
      case DrinkCategory.coffee:
        return 'Кофе';
      case DrinkCategory.tea:
        return 'Чай';
      case DrinkCategory.lemonade:
        return 'Лимонад';
      case DrinkCategory.seasonal:
        return 'Сезонное';
    }
  }

  String get slug => name;
}

DrinkCategory? drinkCategoryFromSlug(String? value) {
  for (final category in DrinkCategory.values) {
    if (category.slug == value) return category;
  }
  return null;
}

class Drink {
  const Drink({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.isPopular,
    required this.isSeasonal,
    required this.isCold,
    required this.imageEmoji,
    this.imageAsset, 
  });

  final String id;
  final String name;
  final DrinkCategory category;
  final String description;

  final int price;
  final int calories;
  final double protein;
  final double fat;
  final double carbs;

  final bool isPopular;
  final bool isSeasonal;
  final bool isCold;

  final String imageEmoji;
  final String? imageAsset; 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category.slug,
      'description': description,
      'price': price,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'isPopular': isPopular,
      'isSeasonal': isSeasonal,
      'isCold': isCold,
      'imageEmoji': imageEmoji,
      'imageAsset': imageAsset,
    };
  }

  factory Drink.fromMap(Map<String, dynamic> map) {
    return Drink(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category:
          drinkCategoryFromSlug(map['category'] as String?) ??
          DrinkCategory.matcha,
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0,
      isPopular: map['isPopular'] as bool? ?? false,
      isSeasonal: map['isSeasonal'] as bool? ?? false,
      isCold: map['isCold'] as bool? ?? true,
      imageEmoji: map['imageEmoji'] as String? ?? '🥤',
      imageAsset: map['imageAsset'] as String?, 
    );
  }
}
