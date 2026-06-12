import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../state/app_controller.dart';
import '../widgets/drink_card.dart';
import '../widgets/empty_state_card.dart';
import 'drink_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Drink> get _results {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.controller.drinks;
    return widget.controller.drinks.where((drink) {
      return drink.name.toLowerCase().contains(query) ||
          drink.description.toLowerCase().contains(query) ||
          drink.category.label.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _openDrink(Drink drink) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            DrinkScreen(controller: widget.controller, drink: drink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 360;
            return TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: isSmall ? 'Поиск...' : 'Поиск напитков...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: const Color(0xFF7A6E69),
                  fontSize: isSmall ? 14 : 16,
                ),
                contentPadding: EdgeInsets.only(
                  left: 8, 
                  top: 12,
                  bottom: 12,
                ),
              ),
              style: TextStyle(
                fontSize: isSmall ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
              icon: const Icon(Icons.clear_rounded),
            ),
        ],
      ),
      body: _results.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: EmptyStateCard(
                  icon: Icons.search_off_rounded,
                  title: 'Ничего не найдено',
                  description: 'Попробуй изменить запрос',
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final drink = _results[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DrinkCard(
                    drink: drink,
                    isFavorite: widget.controller.isFavorite(drink.id),
                    onTap: () => _openDrink(drink),
                    onToggleFavorite: () =>
                        widget.controller.toggleFavorite(drink.id),
                  ),
                );
              },
            ),
    );
  }
}
