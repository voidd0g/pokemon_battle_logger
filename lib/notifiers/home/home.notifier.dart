import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/states/home/home.state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> implements IReloadablePage {
  static const _defaultState = HomeState(
    selectedPageIndex: 1,
  );

  HomeNotifier()
      : super(
          _defaultState,
        );

  Future<void> changePage(int newPageIndex) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newSelectedPageIndex: newPageIndex,
      );
    });
  }

  @override
  Future<void> reload() async {
    await Future.delayed(Duration.zero, () {
      state = _defaultState;
    });
  }
}
