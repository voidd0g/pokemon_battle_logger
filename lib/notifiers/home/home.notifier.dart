import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/routing/home_pages.dart';
import 'package:pokemon_battle_logger/states/home/home.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> implements INotifier {
  static const HomeState _defaultState = HomeState(
    stateName: HomeStateName.notInitialized,
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
  Future<void> reset() async {
    if (state.stateName == HomeStateName.normal) {
      await Future.delayed(Duration.zero, () {
        state = _defaultState;
      });
    }
  }

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: HomeStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: HomeStateName.normal,
      );
    });
  }
}
