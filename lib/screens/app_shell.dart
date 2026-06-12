import 'package:flutter/material.dart';
import '../state/app_controller.dart';
import 'cart_screen.dart';
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
          CartScreen(controller: controller),
        ];

        return Scaffold(
          appBar: controller.selectedTabIndex == 0
              ? null
              : AppBar(
                  title: const Text('Корзина'),
                  actions: <Widget>[
                    IconButton(
                      tooltip: 'Выйти',
                      onPressed: controller.logout,
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
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
