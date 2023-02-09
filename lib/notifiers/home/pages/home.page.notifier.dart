import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/home.page.state.dart';

final homePageProvider = StateNotifierProvider<HomePageNotifier, HomePageState>((ref) => HomePageNotifier());

class HomePageNotifier extends StateNotifier<HomePageState> implements INotifier {
  static const _defaultState = HomePageState(
    stateName: HomePageStateName.notInitialized,
  );
  HomePageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> reset() async {
    if (state.stateName == HomePageStateName.normal) {
      await Future.delayed(Duration.zero, () {
        state = _defaultState;
      });
    }
  }

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: HomePageStateName.initializing,
      );
    });
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: HomePageStateName.normal,
      );
    });
  }
}
