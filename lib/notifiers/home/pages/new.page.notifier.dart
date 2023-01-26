import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/new.page.state.dart';

final newPageProvider = StateNotifierProvider<NewPageNotifier, NewPageState>((ref) => NewPageNotifier());

class NewPageNotifier extends StateNotifier<NewPageState> implements INotifier {
  static const _defaultState = NewPageState(
    stateName: NewPageStateName.notInitialized,
  );
  NewPageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: NewPageStateName.initializing,
      );
    });
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: NewPageStateName.normal,
      );
    });
  }

  @override
  Future<void> reload(IReloadableArg? _) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: NewPageStateName.reloading,
      );
    });
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: NewPageStateName.normal,
      );
    });
  }
}
