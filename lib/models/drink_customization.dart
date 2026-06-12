import 'drink.dart';

class DrinkCustomization {
  final bool showSize;
  final bool showIce;
  final bool showSugar;
  final bool showMilk;
  final bool showSyrups;
  final bool showToppings;
  final bool showNote;

  const DrinkCustomization({
    required this.showSize,
    required this.showIce,
    required this.showSugar,
    required this.showMilk,
    required this.showSyrups,
    required this.showToppings,
    required this.showNote,
  });

  /// Определяет доступные опции на основе категории и типа напитка
  factory DrinkCustomization.forDrink(Drink drink) {
    switch (drink.category) {
      case DrinkCategory.coffee:
        return DrinkCustomization(
          showSize: true,
          showIce: drink.isCold, // Только для холодного кофе
          showSugar: true,
          showMilk: true,
          showSyrups: true,
          showToppings: true,
          showNote: true,
        );

      case DrinkCategory.matcha:
        return DrinkCustomization(
          showSize: true,
          showIce: drink.isCold, // Только для холодной матчи
          showSugar: true,
          showMilk: true,
          showSyrups: true,
          showToppings: true, // Сырная пенка, тапиока
          showNote: true,
        );

      case DrinkCategory.tea:
        return DrinkCustomization(
          showSize: true,
          showIce: drink.isCold, // Только для холодного чая
          showSugar: true,
          showMilk: false, // Чай обычно без молока
          showSyrups: false, // Чистый чай без сиропов
          showToppings: false, // Без топпингов
          showNote: true,
        );

      case DrinkCategory.lemonade:
        return DrinkCustomization(
          showSize: true,
          showIce: true, // Лимонады всегда со льдом
          showSugar: false, // Сладость уже заложена
          showMilk: false,
          showSyrups: false,
          showToppings: false,
          showNote: true,
        );

      case DrinkCategory.seasonal:
        return DrinkCustomization(
          showSize: true,
          showIce: !drink.isCold, // Инверсия: если не горячий — показываем лёд
          showSugar: true,
          showMilk:
              drink.name.toLowerCase().contains('кокос') ||
              drink.name.toLowerCase().contains(
                'молоко',
              ), // Только если есть молоко в составе
          showSyrups: false, // Сезонные напитки уже сбалансированы
          showToppings: false,
          showNote: true,
        );
    }
  }
}
