import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/views/home/home.view.dart';
import 'package:pokemon_battle_logger/views/user/user.view.dart';

class AppRouting {
  static const String home = '/';
  static const String user = '/user';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const HomeView(),
        );
      case user:
        return MaterialPageRoute(
          builder: (context) => const UserView(),
        );
    }
    return null;
  }
}
