import 'package:pokemon_battle_logger/notifier_args/pokemon_detail/pokemon_detail.notifier.arg.dart';

class PokemonDetailState {
  final PokemonDetailStateName stateName;
  final PokemonDetailNotifierArg? arg;
  const PokemonDetailState({
    required this.stateName,
    required this.arg,
  });

  PokemonDetailState copy({PokemonDetailStateName? newStateName, PokemonDetailNotifierArg? newArg}) {
    return PokemonDetailState(
      stateName: newStateName ?? stateName,
      arg: newArg ?? arg,
    );
  }
}

enum PokemonDetailStateName {
  notInitialized,
  initializing,
  normal,
  redirecting,
}
