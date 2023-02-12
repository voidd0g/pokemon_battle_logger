import 'package:pokemon_battle_logger/notifier_args/pokemon_edit/pokemon_edit.notifier.arg.dart';

class PokemonEditState {
  final PokemonEditStateName stateName;
  final PokemonEditNotifierArg? arg;
  const PokemonEditState({
    required this.stateName,
    required this.arg,
  });

  PokemonEditState copy({PokemonEditStateName? newStateName, PokemonEditNotifierArg? newArg}) {
    return PokemonEditState(
      stateName: newStateName ?? stateName,
      arg: newArg ?? arg,
    );
  }
}

enum PokemonEditStateName {
  notInitialized,
  initializing,
  normal,
  redirecting,
}
