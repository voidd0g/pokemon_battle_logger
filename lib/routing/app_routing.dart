import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/views/home/home.view.dart';
import 'package:pokemon_battle_logger/views/pokemon/pokemon.view.dart';
import 'package:pokemon_battle_logger/views/pokemon_detail/pokemon_detail.view.dart';
import 'package:pokemon_battle_logger/views/user/user_settings.view.dart';

class AppRouting {
  static const String home = '/';
  static const String user = '/user';
  static const String pokemon = '/pokemon';
  static const String pokemonDetail = '/pokemon_detail';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomeView(),
        );
      case user:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const UserSettingsView(),
        );
      case pokemon:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PokemonView(),
        );
      case pokemonDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PokemonDetailView(),
        );
    }
    return null;
  }
}
