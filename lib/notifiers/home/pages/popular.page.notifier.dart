import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/states/home/pages/popular.page.state.dart';

final popularPageProvider = StateNotifierProvider<PopularPageNotifier, PopularPageState>((ref) => PopularPageNotifier());

class PopularPageNotifier extends StateNotifier<PopularPageState> implements IReloadablePage {
  static const _defaultState = PopularPageState(
    isReloading: false,
  );
  PopularPageNotifier()
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