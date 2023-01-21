import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/states/home/pages/home.page.state.dart';

final homePageProvider = StateNotifierProvider<HomePageNotifier, HomePageState>((ref) => HomePageNotifier());

class HomePageNotifier extends StateNotifier<HomePageState> implements IReloadablePage {
  static const _defaultState = HomePageState(
    isReloading: false,
  );
  HomePageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> reload() async {
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
