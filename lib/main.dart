import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/views/app.view.dart';

void main() {
  runApp(const ProviderScope(child: PokemonBattleLoggerApp()));
}
