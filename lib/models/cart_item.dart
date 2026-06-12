import 'drink.dart';
import 'drink_option.dart';

class CartItem {
  const CartItem({
    required this.drink,
    required this.option,
    required this.quantity,
  });

  final Drink drink;
  final DrinkOption option;
  final int quantity;

  int get unitPrice {
    return drink.price + option.size.extraPrice + extrasPrice;
  }

  int get extrasPrice {
    int sum = 0;
    for (final extra in option.extras) {
      switch (extra) {
        case 'tapioca':
          sum += 40;
          break;
        case 'sirup':
          sum += 25;
          break;
        case 'oat_milk':
          sum += 35;
          break;
        case 'berry':
          sum += 30;
          break;
        case 'espresso':
          sum += 45;
          break;
        default:
          sum += 0;
      }
    }
    return sum;
  }

  int get totalPrice => unitPrice * quantity;

  CartItem copyWith({Drink? drink, DrinkOption? option, int? quantity}) {
    return CartItem(
      drink: drink ?? this.drink,
      option: option ?? this.option,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'drinkId': drink.id,
      'option': option.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, {required Drink drink}) {
    return CartItem(
      drink: drink,
      option: DrinkOption.fromMap(
        Map<String, dynamic>.from(map['option'] as Map? ?? <String, dynamic>{}),
      ),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
