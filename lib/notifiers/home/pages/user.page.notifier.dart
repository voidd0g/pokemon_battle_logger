import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/states/home/pages/user.page.state.dart';

final userPageProvider = StateNotifierProvider<UserPageNotifier, UserPageState>((ref) => UserPageNotifier());

class UserPageNotifier extends StateNotifier<UserPageState> implements INotifier {
  static const _defaultState = UserPageState(
    stateName: UserPageStateName.notInitialized,
  );
  UserPageNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> reset() async {
    if (state.stateName == UserPageStateName.normal) {
      await Future.delayed(Duration.zero, () {
        state = _defaultState;
      });
    }
  }

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserPageStateName.initializing,
      );
    });
    await UserServices.instance.checkCacheSignedIn();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserPageStateName.normal,
      );
    });
  }

  Future<bool> trySignIn() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserPageStateName.signingIn,
      );
    });
    final user = await UserServices.instance.signInWithGoogle();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserPageStateName.normal,
      );
    });
    return user != null;
  }

  Future<void> signOut() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserPageStateName.signingOut,
      );
    });
    await UserServices.instance.signOutFromGoogle();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserPageStateName.normal,
      );
    });
  }
}
