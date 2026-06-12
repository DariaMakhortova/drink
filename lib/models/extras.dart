class Extras {
  static const Map<String, String> labels = {
    'tapioca': 'Тапиока',
    'sirup': 'Сироп',
    'oat_milk': 'Овсяное молоко',
    'berry': 'Ягоды',
    'espresso': 'Шот эспрессо',
  };

  static const Map<String, int> prices = {
    'tapioca': 40,
    'sirup': 25,
    'oat_milk': 35,
    'berry': 30,
    'espresso': 45,
  };

  static String getLabel(String slug) {
    return labels[slug] ?? slug;
  }

  static int getPrice(String slug) {
    return prices[slug] ?? 0;
  }

  static List<String> get allSlugs => labels.keys.toList();
}
