import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/search.page.state.dart';

final searchPageProvider = StateNotifierProvider<SearchPageNotifier, SearchPageState>((ref) => SearchPageNotifier());

class SearchPageNotifier extends StateNotifier<SearchPageState> implements INotifier {
  static const _defaultState = SearchPageState(
    stateName: SearchPageStateName.notInitialized,
  );
  SearchPageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: SearchPageStateName.initializing,
      );
    });
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: SearchPageStateName.normal,
      );
    });
  }

  @override
  Future<void> reload(IReloadableArg? _) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: SearchPageStateName.reloading,
      );
    });
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: SearchPageStateName.normal,
      );
    });
  }
}
