import 'package:flutter/material.dart';
import '../state/app_controller.dart';
import '../widgets/drink_card.dart';
import '../widgets/empty_state_card.dart';
import 'drink_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final favorites = controller.favoriteDrinks;

        return SafeArea(
          child: Column(
            children: [
              // Заголовок
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Избранное',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
              // Список избранного
              Expanded(
                child: favorites.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: EmptyStateCard(
                            icon: Icons.favorite_border_rounded,
                            title: 'Пока нет избранного',
                            description:
                                'Нажимай на сердечко в карточках напитков, чтобы сохранить их здесь',
                            actionLabel: 'Перейти к напиткам',
                            onPressed: () => controller.setSelectedTab(0),
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 600
                              ? 3
                              : 2;
                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              final drink = favorites[index];
                              return DrinkCard(
                                drink: drink,
                                isFavorite: true,
                                onTap: () => _openDrink(context, drink),
                                onToggleFavorite: () =>
                                    controller.toggleFavorite(drink.id),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openDrink(BuildContext context, drink) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DrinkScreen(controller: controller, drink: drink),
      ),
    );
  }
}
