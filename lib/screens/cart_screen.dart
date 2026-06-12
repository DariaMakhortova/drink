import 'package:flutter/material.dart';
import '../models/drink_option.dart';
import '../state/app_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.controller});

  final AppController controller;

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
                              : 'Товаров в корзине: ${controller.cartCount}',
                          style: const TextStyle(
                            color: Color(0xFF6C5E59),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: controller.clearCart,
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE2E7EA)),
                  ),
                  child: const Column(
                    children: <Widget>[
                      Icon(Icons.shopping_bag_outlined, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Корзина пустая',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4B3935),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Добавь напитки с главной или из карточки товара.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF6C5E59),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
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
                                    'Добавки: ${item.option.extras.join(', ')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6C5E59),
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
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    _QtyButton(
                                      icon: Icons.remove_rounded,
                                      onTap: () =>
                                          controller.decrementCartItem(index),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    _QtyButton(
                                      icon: Icons.add_rounded,
                                      onTap: () =>
                                          controller.incrementCartItem(index),
                                    ),
                                  ],
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
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE2E7EA)),
                ),
                child: Column(
                  children: <Widget>[
                    _TotalRow(
                      label: 'Сумма',
                      value: '${controller.cartTotal} ₽',
                    ),
                    const SizedBox(height: 8),
                    _TotalRow(label: 'Доставка', value: '0 ₽'),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    _TotalRow(
                      label: 'Итого',
                      value: '${controller.cartTotal} ₽',
                      bold: true,
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: items.isEmpty
                          ? null
                          : () async {
                              await controller.checkout();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Заказ оформлен'),
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

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F0EE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF4B3935)),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            color: const Color(0xFF4B3935),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            color: const Color(0xFF4B3935),
          ),
        ),
      ],
    );
  }
}
