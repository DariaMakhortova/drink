import 'drink.dart';
import 'drink_option.dart';
import 'extras.dart';

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
      sum += Extras.getPrice(extra);
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
