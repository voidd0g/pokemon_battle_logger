import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';

void main() {
  runApp(const ProviderScope(child: PokemonBattleLoggerApp()));
}

class PokemonBattleLoggerApp extends StatelessWidget {
  const PokemonBattleLoggerApp({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Pokemon Battle Logger',
      initialRoute: AppRouting.home,
      onGenerateRoute: AppRouting.generateRoute,
    );
  }
}
