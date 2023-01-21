import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/states/home/pages/search.page.state.dart';

final searchPageProvider = StateNotifierProvider<SearchPageNotifier, SearchPageState>((ref) => SearchPageNotifier());

class SearchPageNotifier extends StateNotifier<SearchPageState> implements IReloadablePage {
  static const _defaultState = SearchPageState(
    isReloading: false,
  );
  SearchPageNotifier()
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
