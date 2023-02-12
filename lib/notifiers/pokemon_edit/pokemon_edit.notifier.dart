import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon_edit/pokemon_edit.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/repos/pokemon_trained.services.dart';
import 'package:pokemon_battle_logger/states/pokemon_edit/pokemon_edit.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final pokemonEditProvider = StateNotifierProvider<PokemonEditNotifier, PokemonEditState>((ref) => PokemonEditNotifier());

class PokemonEditNotifier extends StateNotifier<PokemonEditState> implements INotifier {
  static const PokemonEditState _defaultState = PokemonEditState(
    stateName: PokemonEditStateName.notInitialized,
    arg: null,
  );

  PokemonEditNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonEditStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    if (arg == null) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: PokemonEditStateName.redirecting,
        );
      });
    }
    await PokemonServices.instance.getAllAvailablePokemons();
    await PokemonTrainedServices.instance.getAllAvailablePokemonsTrained(uid: (arg as PokemonEditNotifierArg).uid);
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonEditStateName.normal,
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
