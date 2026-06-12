import 'package:flutter/material.dart';
import '../state/app_controller.dart';
import 'cart_screen.dart';
import 'favorites_screens.dart';
import 'home_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final screens = <Widget>[
          HomeScreen(controller: controller),
          FavoritesScreen(controller: controller),
          CartScreen(controller: controller),
        ];

        return Scaffold(
          body: IndexedStack(
            index: controller.selectedTabIndex,
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedTabIndex,
            onDestinationSelected: controller.setSelectedTab,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Главная',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Избранное',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag_rounded),
                label: 'Корзина',
              ),
            ],
          ),
        );
      },
    );
  }
}
