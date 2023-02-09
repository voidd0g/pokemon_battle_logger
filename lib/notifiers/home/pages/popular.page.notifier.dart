import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/popular.page.state.dart';

final popularPageProvider = StateNotifierProvider<PopularPageNotifier, PopularPageState>((ref) => PopularPageNotifier());

class PopularPageNotifier extends StateNotifier<PopularPageState> implements INotifier {
  static const _defaultState = PopularPageState(
    stateName: PopularPageStateName.notInitialized,
  );
  PopularPageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> reset() async {
    if (state.stateName == PopularPageStateName.normal) {
      await Future.delayed(Duration.zero, () {
        state = _defaultState;
      });
    }
  }

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PopularPageStateName.initializing,
      );
    });
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: PopularPageStateName.normal,
      );
    });
  }
}
