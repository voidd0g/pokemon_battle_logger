import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon_detail/pokemon_detail.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/repos/pokemon_trained.services.dart';
import 'package:pokemon_battle_logger/states/pokemon_detail/pokemon_detail.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final pokemonDetailProvider = StateNotifierProvider<PokemonDetailNotifier, PokemonDetailState>((ref) => PokemonDetailNotifier());

class PokemonDetailNotifier extends StateNotifier<PokemonDetailState> implements INotifier {
  static const PokemonDetailState _defaultState = PokemonDetailState(
    stateName: PokemonDetailStateName.notInitialized,
    arg: null,
  );

  PokemonDetailNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonDetailStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    if (arg == null) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: PokemonDetailStateName.redirecting,
        );
      });
    }
    await PokemonServices.instance.getAllAvailablePokemons();
    await PokemonTrainedServices.instance.getAllAvailablePokemonsTrained(uid: (arg as PokemonDetailNotifierArg).uid);
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonDetailStateName.normal,
        newArg: arg,
      );
    });
  }

  @override
  Future<void> reset() async {
    await Future.delayed(Duration.zero, () {
      state = _defaultState;
    });
  }
}
