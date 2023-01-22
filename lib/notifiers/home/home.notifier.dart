import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/routing/home_pages.dart';
import 'package:pokemon_battle_logger/states/home/home.state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> implements IReloadablePage {
  static const HomeState _defaultState = HomeState(
    selectedPageIndicesStack: [HomePages.homePageIndex],
  );

  HomeNotifier()
      : super(
          _defaultState,
        );

  Future<void> changePage(int newPageIndex) async {
    final List<int> newStack = [...state.selectedPageIndicesStack];
    if (newStack.contains(newPageIndex)) {
      newStack.removeWhere((element) => element == newPageIndex);
    }
    if (newStack.first != HomePages.homePageIndex) {
      newStack.insert(0, HomePages.homePageIndex);
    } else if (newStack.length > 1 && newStack[1] == HomePages.homePageIndex) {
      newStack.removeAt(0);
    }
    newStack.add(newPageIndex);
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newSelectedPageIndicesStack: newStack,
      );
    });
  }

  Future<bool> popPage() async {
    final int len = state.selectedPageIndicesStack.length;
    if (len == 1) {
      return true;
    } else {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newSelectedPageIndicesStack: state.selectedPageIndicesStack.sublist(0, len - 1),
        );
      });
      return false;
    }
  }

  @override
  Future<void> reload(IReloadableArg? _) async {
    await Future.delayed(Duration.zero, () {
      state = _defaultState;
    });
  }
}
