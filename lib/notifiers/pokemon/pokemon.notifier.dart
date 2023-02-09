import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon/pokemon.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/repos/pokemon_trained.services.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/states/pokemon/pokemon.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final pokemonProvider = StateNotifierProvider<PokemonNotifier, PokemonState>((ref) => PokemonNotifier());

class PokemonNotifier extends StateNotifier<PokemonState> implements INotifier {
  static const PokemonState _defaultState = PokemonState(
    stateName: PokemonStateName.notInitialized,
    arg: null,
  );

  PokemonNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    if (arg == null && UserServices.instance.currentUser == null) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: PokemonStateName.redirecting,
        );
      });
    }
    String uid = arg != null ? (arg as PokemonNotifierArg).uid : UserServices.instance.currentUser!.uid;
    await PokemonServices.instance.getAllAvailablePokemons();
    await PokemonTrainedServices.instance.getAllAvailablePokemonsTrained(uid: uid);
    if (kDebugMode) {
      print(PokemonServices.instance.pokemons);
      print(PokemonTrainedServices.instance.pokemonsTrainedByUsers[uid]);
    }
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PokemonStateName.normal,
        newArg: arg as PokemonNotifierArg?,
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
