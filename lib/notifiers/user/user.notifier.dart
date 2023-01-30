import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/states/user/user.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<UserState> implements INotifier {
  static const UserState _defaultState = UserState(
    stateName: UserStateName.notInitialized,
  );

  UserNotifier()
      : super(
          _defaultState,
        );

  @override
  Future<void> reset() async {
    await Future.delayed(Duration.zero, () {
      state = _defaultState;
    });
  }

  @override
  Future<void> initialize({INotifierArg? arg}) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    if (UserServices.instance.currentUser == null) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserStateName.redirecting,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserStateName.normal,
        );
      });
    }
  }

  Future<bool> pickImageAndUpdateIcon(ImageSource source) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.changing,
      );
    });
    bool res = false;
    final path = await UserServices.instance.pickImage(source);
    if (path != null) {
      res = await UserServices.instance.updateIcon(path);
    }
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.normal,
      );
    });
    return res;
  }

  Future<void> deleteIcon() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.changing,
      );
    });
    await UserServices.instance.deleteIcon();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.normal,
      );
    });
  }

  Future<void> resetIcon() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.changing,
      );
    });
    await UserServices.instance.resetIcon();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.normal,
      );
    });
  }

  Future<bool> updateDisplayName(String newName) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.changing,
      );
    });
    bool res = false;
    if (newName != '') {
      res = await UserServices.instance.updateDisplayName(newName);
    }
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.normal,
      );
    });
    return res;
  }

  Future<void> resetDisplayName() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.changing,
      );
    });
    await UserServices.instance.resetDisplayName();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.normal,
      );
    });
  }

  Future<bool> deleteAccount() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserStateName.changing,
      );
    });
    bool res = await UserServices.instance.deleteUser();
    if (res) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserStateName.redirecting,
        );
      });
      return true;
    } else {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserStateName.normal,
        );
      });
      return false;
    }
  }
}
