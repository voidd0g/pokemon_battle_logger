import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';

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
