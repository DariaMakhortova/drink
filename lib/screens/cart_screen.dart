import 'package:flutter/material.dart';
import '../models/drink_option.dart';
import '../state/app_controller.dart';
import '../models/extras.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/total_row.dart';
import '../widgets/empty_state_card.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.controller});
  final AppController controller;

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы сможете войти снова в любое время.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await controller.logout();
    }
  }

  String _translateExtras(List<String> extras) {
    return extras.map((e) => Extras.getLabel(e)).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final items = controller.cartItems;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: <Widget>[
              // Шапка корзины: заголовок + мусорка + выход
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Корзина',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4B3935),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          items.isEmpty
                              ? 'Пока пусто'
                              : 'Товаров: ${controller.cartCount}',
                          style: const TextStyle(
                            color: Color(0xFF6C5E59),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Кнопка очистки корзины
                  if (items.isNotEmpty)
                    IconButton(
                      tooltip: 'Очистить корзину',
                      onPressed: controller.clearCart,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFF4B3935),
                      ),
                    ),
                  // Кнопка выхода из аккаунта
                  IconButton(
                    tooltip: 'Выйти из аккаунта',
                    onPressed: () => _confirmLogout(context),
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFF4B3935),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Пустое состояние или список
              if (items.isEmpty)
                EmptyStateCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Корзина пустая',
                  description:
                      'Добавь напитки с главной или из карточки товара.',
                  actionLabel: 'Перейти к напиткам',
                  onPressed: () => controller.setSelectedTab(0),
                )
              else
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFFE2E7EA)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFFF7FBFD),
                                  Color(0xFFDCEBF3),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                item.drink.imageEmoji,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.drink.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF4B3935),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.option.size.label} · ${item.option.iceLevel.label} · ${item.option.sugarLevel.label}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6C5E59),
                                  ),
                                ),
                                if (item.option.extras.isNotEmpty) ...<Widget>[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Добавки: ${_translateExtras(item.option.extras)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6C5E59),
                                    ),
                                  ),
                                ],
                                if (item.option.note.isNotEmpty) ...<Widget>[
                                  const SizedBox(height: 4),
                                  Text(
                                    '«${item.option.note}»',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6C5E59),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${item.totalPrice} ₽',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF4B3935),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () =>
                                          controller.removeCartItem(index),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                        color: Color(0xFF6C5E59),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: QuantityStepper(
                                    value: item.quantity,
                                    onDecrement: () =>
                                        controller.decrementCartItem(index),
                                    onIncrement: () =>
                                        controller.incrementCartItem(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 4),
              // Итоговый блок
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE2E7EA)),
                  ),
                  child: Column(
                    children: <Widget>[
                      TotalRow(
                        label: 'Сумма',
                        value: '${controller.cartTotal} ₽',
                      ),
                      const SizedBox(height: 8),
                      TotalRow(label: 'Доставка', value: '0 ₽'),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      TotalRow(
                        label: 'Итого',
                        value: '${controller.cartTotal} ₽',
                        bold: true,
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: () async {
                          await controller.checkout();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Заказ успешно оформлен!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('Оформить заказ'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
