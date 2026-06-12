import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../state/app_controller.dart';
import '../widgets/drink_card.dart';
import '../widgets/section_title.dart';
import 'drink_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.controller.searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openDrink(Drink drink) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            DrinkScreen(controller: widget.controller, drink: drink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final drinks = widget.controller.filteredDrinks;
        final popular = widget.controller.popularDrinks;
        final featuredDrink = popular.isNotEmpty
            ? popular.first
            : widget.controller.drinks.first;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Привет, ${widget.controller.firstName}!',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Собери свой идеальный напиток.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.controller.setSelectedTab(1),
                      icon: const Icon(Icons.shopping_bag_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
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
                    children: <Widget>[
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
                        style: const TextStyle(
                          color: Color(0xFFF5EFED),
                          height: 1.45,
                        ),
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
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: widget.controller.setSearchQuery,
                  decoration: const InputDecoration(
                    labelText: 'Поиск напитка',
                    hintText: 'Например: матча, кофе',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = DrinkCategory.values[index];
                      final isSelected =
                          widget.controller.selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category.label),
                        selected: isSelected,
                        onSelected: (_) {
                          widget.controller.setSelectedCategory(
                            isSelected ? null : category,
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: DrinkCategory.values.length,
                  ),
                ),
                const SizedBox(height: 18),
                SectionTitle(
                  title: 'Популярное',
                  action: 'Сбросить',
                  onAction: widget.controller.clearFilters,
                ),
                const SizedBox(height: 10),
                _DrinkGrid(
                  items: popular,
                  onTap: _openDrink,
                  controller: widget.controller,
                ),
                const SizedBox(height: 18),
                SectionTitle(
                  title: 'Все напитки',
                  action: 'Корзина',
                  onAction: () => widget.controller.setSelectedTab(1),
                ),
                const SizedBox(height: 10),
                _DrinkGrid(
                  items: drinks,
                  onTap: _openDrink,
                  controller: widget.controller,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DrinkGrid extends StatelessWidget {
  const _DrinkGrid({
    required this.items,
    required this.onTap,
    required this.controller,
  });
  final List<Drink> items;
  final Future<void> Function(Drink) onTap;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE2E7EA)),
        ),
        child: const Text('Ничего не найдено. Попробуй другой поиск.'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивное количество колонок
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth >= 600) {
          crossAxisCount = 3;
          childAspectRatio = 0.85;
        } else if (constraints.maxWidth >= 400) {
          crossAxisCount = 2;
          childAspectRatio = 0.85;
        } else {
          // Маленькие экраны - 1 колонка
          crossAxisCount = 1;
          childAspectRatio = 3.5;
        }

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final drink = items[index];
            return DrinkCard(
              drink: drink,
              isFavorite: controller.isFavorite(drink.id),
              onTap: () => onTap(drink),
              onToggleFavorite: () => controller.toggleFavorite(drink.id),
            );
          },
        );
      },
    );
  }
}
