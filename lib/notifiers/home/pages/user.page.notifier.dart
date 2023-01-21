import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/states/home/pages/user.page.state.dart';

final userPageProvider = StateNotifierProvider<UserPageNotifier, UserPageState>((ref) => UserPageNotifier());

class UserPageNotifier extends StateNotifier<UserPageState> implements IReloadablePage {
  static const _defaultState = UserPageState(
    isReloading: false,
  );
  UserPageNotifier()
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
