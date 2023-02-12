import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/states/pokemon_choose/pokemon_choose.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final pokemonChooseProvider = StateNotifierProvider<PokemonChooseNotifier, PokemonChooseState>((ref) => PokemonChooseNotifier());

class PokemonChooseNotifier extends StateNotifier<PokemonChooseState> implements INotifier {
  static const PokemonChooseState _defaultState = PokemonChooseState(
    stateName: PokemonChooseStateName.notInitialized,
  );

  PokemonChooseNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonChooseStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    await PokemonServices.instance.getAllAvailablePokemons();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonChooseStateName.normal,
      );
    });
  }

  @override
  Future<void> reset() async {
    await Future.delayed(Duration.zero, () {
      state = _defaultState;
    });
  }

  void updateSearch(String value) {
    Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonChooseStateName.normal,
      );
    });
  }
}
