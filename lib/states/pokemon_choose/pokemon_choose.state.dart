class PokemonChooseState {
  final PokemonChooseStateName stateName;
  const PokemonChooseState({
    required this.stateName,
  });

  PokemonChooseState copy({
    PokemonChooseStateName? newStateName,
  }) {
    return PokemonChooseState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum PokemonChooseStateName {
  notInitialized,
  initializing,
  normal,
  redirecting,
}
