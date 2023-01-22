import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/states/home/pages/new.page.state.dart';

final newPageProvider = StateNotifierProvider<NewPageNotifier, NewPageState>((ref) => NewPageNotifier());

class NewPageNotifier extends StateNotifier<NewPageState> implements IReloadablePage {
  static const _defaultState = NewPageState(
    isReloading: false,
  );
  NewPageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> reload(IReloadableArg? _) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newIsReloading: true,
      );
    });
    await Future.delayed(const Duration(seconds: 2), () {});
    await Future.delayed(Duration.zero, () {
      state = _defaultState;
    });
  }
}
