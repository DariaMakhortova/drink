import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../state/app_controller.dart';
import '../widgets/drink_card.dart';
import '../widgets/empty_state_card.dart';
import 'drink_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<DrinkCategory?> _categories;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // null = "Популярное" (показывает только популярные напитки)
    _categories = [null, ...DrinkCategory.values];
  }

  List<Drink> _getDrinksForCategory(DrinkCategory? category) {
    List<Drink> drinks;
    if (category == null) {
      // Показываем только популярные напитки
      drinks = widget.controller.popularDrinks;
    } else {
      drinks = widget.controller.drinks
          .where((d) => d.category == category)
          .toList();
    }
    // Создаем копию списка перед сортировкой
    final sortedDrinks = List<Drink>.from(drinks);
    sortedDrinks.sort((a, b) {
      if (a.isPopular && !b.isPopular) return -1;
      if (!a.isPopular && b.isPopular) return 1;
      return a.price.compareTo(b.price);
    });
    return sortedDrinks;
  }

  Future<void> _openSearch() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SearchScreen(controller: widget.controller),
      ),
    );
  }

  Future<void> _openDrink(Drink drink) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            DrinkScreen(controller: widget.controller, drink: drink),
      ),
    );
  }

  String _getCategoryLabel(DrinkCategory? category) {
    if (category == null) {
      return 'Популярное';
    }
    return category.label;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final drinks = _getDrinksForCategory(
          _categories[_selectedCategoryIndex],
        );

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Шапка с приветствием и поиском (без кнопки выхода)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Привет, ${widget.controller.firstName}!',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Что будешь заказывать?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _openSearch,
                      icon: const Icon(Icons.search_rounded, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Баннер "Сегодня в топе"
                _buildBanner(),
                const SizedBox(height: 16),
                // Табы категорий (горизонтальный скролл)
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategoryIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_getCategoryLabel(category)),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedCategoryIndex = index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Сетка напитков (меняется при смене категории)
                if (drinks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: EmptyStateCard(
                      icon: Icons.local_cafe_outlined,
                      title: 'Напитков пока нет',
                      description:
                          'В этой категории скоро появятся новые позиции',
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 600
                          ? 3
                          : 2;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: drinks.length,
                        itemBuilder: (context, index) {
                          final drink = drinks[index];
                          return DrinkCard(
                            drink: drink,
                            isFavorite: widget.controller.isFavorite(drink.id),
                            onTap: () => _openDrink(drink),
                            onToggleFavorite: () =>
                                widget.controller.toggleFavorite(drink.id),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    final popular = widget.controller.popularDrinks;
    final featuredDrink = popular.isNotEmpty
        ? popular.first
        : widget.controller.drinks.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF4B3935), Color(0xFF6A534D)],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A4B3935),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Сегодня в топе',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            featuredDrink.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            featuredDrink.description,
            style: const TextStyle(color: Color(0xFFF5EFED), height: 1.45),
          ),
          const SizedBox(height: 14),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4B3935),
            ),
            onPressed: () => _openDrink(featuredDrink),
            child: const Text('Открыть товар'),
          ),
        ],
      ),
    );
  }
}
