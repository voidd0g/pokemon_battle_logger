import 'package:pokemon_battle_logger/notifier_args/pokemon/pokemon.notifier.arg.dart';

class PokemonState {
  final PokemonStateName stateName;
  final PokemonNotifierArg? arg;
  const PokemonState({
    required this.stateName,
    required this.arg,
  });

  PokemonState copy({PokemonStateName? newStateName, PokemonNotifierArg? newArg}) {
    return PokemonState(
      stateName: newStateName ?? stateName,
      arg: newArg ?? arg,
    );
  }
}

enum PokemonStateName {
  notInitialized,
  initializing,
  normal,
  redirecting,
}
