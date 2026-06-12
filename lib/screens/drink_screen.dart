import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../models/drink_option.dart';
import '../state/app_controller.dart';
import '../widgets/info_row.dart';
import '../widgets/extra_chip.dart';
import '../widgets/quantity_stepper.dart';

class DrinkScreen extends StatefulWidget {
  const DrinkScreen({super.key, required this.controller, required this.drink});
  final AppController controller;
  final Drink drink;

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  DrinkSize _size = DrinkSize.medium;
  IceLevel _iceLevel = IceLevel.normal;
  SugarLevel _sugarLevel = SugarLevel.half;
  final Set<String> _extras = <String>{};
  final _noteController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  int _extraPrice(String extra) {
    switch (extra) {
      case 'tapioca':
        return 40;
      case 'sirup':
        return 25;
      case 'oat_milk':
        return 35;
      case 'berry':
        return 30;
      case 'espresso':
        return 45;
      default:
        return 0;
    }
  }

  int get _extrasPrice =>
      _extras.fold<int>(0, (sum, extra) => sum + _extraPrice(extra));

  int get _totalPrice =>
      (widget.drink.price + _size.extraPrice + _extrasPrice) * _quantity;

  int get _caloriesDelta {
    switch (_size) {
      case DrinkSize.small:
        return -15;
      case DrinkSize.medium:
        return 0;
      case DrinkSize.large:
        return 25;
    }
  }

  void _toggleExtra(String extra) {
    setState(() {
      if (_extras.contains(extra)) {
        _extras.remove(extra);
      } else {
        _extras.add(extra);
      }
    });
  }

  void _addToCart() {
    final option = DrinkOption(
      size: _size,
      iceLevel: _iceLevel,
      sugarLevel: _sugarLevel,
      extras: _extras.toList(),
      note: _noteController.text.trim(),
    );

    widget.controller.addToCart(widget.drink, option, quantity: _quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.drink.name} добавлен в корзину'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    widget.controller.setSelectedTab(1);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drink = widget.drink;

    return Scaffold(
      appBar: AppBar(
        title: Text(drink.name),
        actions: <Widget>[
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              final isFavorite = widget.controller.isFavorite(drink.id);
              return IconButton(
                onPressed: () => widget.controller.toggleFavorite(drink.id),
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFFFFFFFF), Color(0xFFDCEBF3)],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white.withOpacity(0.45),
                    ),
                    child: Center(
                      child: Text(
                        drink.imageEmoji,
                        style: const TextStyle(fontSize: 110),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              drink.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              drink.description,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${drink.price} ₽',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4B3935),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            InfoRow(
              calories: drink.calories + _caloriesDelta,
              protein: drink.protein,
              fat: drink.fat,
              carbs: drink.carbs,
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Размер',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DrinkSize.values.map((size) {
                  return ChoiceChip(
                    label: Text(size.label),
                    selected: _size == size,
                    onSelected: (_) => setState(() => _size = size),
                  );
                }).toList(),
              ),
            ),
            _Section(
              title: 'Лёд',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: IceLevel.values.map((ice) {
                  return ChoiceChip(
                    label: Text(ice.label),
                    selected: _iceLevel == ice,
                    onSelected: (_) => setState(() => _iceLevel = ice),
                  );
                }).toList(),
              ),
            ),
            _Section(
              title: 'Сахар',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SugarLevel.values.map((sugar) {
                  return ChoiceChip(
                    label: Text(sugar.label),
                    selected: _sugarLevel == sugar,
                    onSelected: (_) => setState(() => _sugarLevel = sugar),
                  );
                }).toList(),
              ),
            ),
            _Section(
              title: 'Добавки',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  ExtraChip(
                    label: 'Тапиока',
                    selected: _extras.contains('tapioca'),
                    onTap: () => _toggleExtra('tapioca'),
                    priceLabel: '+40 ₽',
                  ),
                  ExtraChip(
                    label: 'Сироп',
                    selected: _extras.contains('sirup'),
                    onTap: () => _toggleExtra('sirup'),
                    priceLabel: '+25 ₽',
                  ),
                  ExtraChip(
                    label: 'Овсяное молоко',
                    selected: _extras.contains('oat_milk'),
                    onTap: () => _toggleExtra('oat_milk'),
                    priceLabel: '+35 ₽',
                  ),
                  ExtraChip(
                    label: 'Ягоды',
                    selected: _extras.contains('berry'),
                    onTap: () => _toggleExtra('berry'),
                    priceLabel: '+30 ₽',
                  ),
                  ExtraChip(
                    label: 'Шот эспрессо',
                    selected: _extras.contains('espresso'),
                    onTap: () => _toggleExtra('espresso'),
                    priceLabel: '+45 ₽',
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Комментарий',
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Например: без трубочки, очень холодный',
                ),
              ),
            ),
            _Section(
              title: 'Количество',
              child: Row(
                children: <Widget>[
                  QuantityStepper(
                    value: _quantity,
                    onDecrement: () => setState(() => _quantity -= 1),
                    onIncrement: () => setState(() => _quantity += 1),
                  ),
                  const Spacer(),
                  Text(
                    'Итого: $_totalPrice ₽',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4B3935),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: _addToCart,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Добавить в корзину'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF4B3935),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
