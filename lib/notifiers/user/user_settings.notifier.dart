import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/states/user/user_settings.state.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

final userSettingsProvider = StateNotifierProvider<UserSettingsNotifier, UserSettingsState>((ref) => UserSettingsNotifier());

class UserSettingsNotifier extends StateNotifier<UserSettingsState> implements INotifier {
  static const UserSettingsState _defaultState = UserSettingsState(
    stateName: UserSettingsStateName.notInitialized,
  );

  UserSettingsNotifier()
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
        newStateName: UserSettingsStateName.initializing,
      );
    });
    await FirebaseUtil.instance.initialize();
    if (UserServices.instance.currentUser == null) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserSettingsStateName.redirecting,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserSettingsStateName.normal,
        );
      });
    }
  }

  Future<bool> pickImageAndUpdateIcon(ImageSource source) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.changing,
      );
    });
    bool res = false;
    final path = await UserServices.instance.pickImage(source);
    if (path != null) {
      res = await UserServices.instance.updateIcon(path);
    }
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.normal,
      );
    });
    return res;
  }

  Future<void> deleteIcon() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.changing,
      );
    });
    await UserServices.instance.deleteIcon();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.normal,
      );
    });
  }

  Future<void> resetIcon() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.changing,
      );
    });
    await UserServices.instance.resetIcon();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.normal,
      );
    });
  }

  Future<bool> updateDisplayName(String newName) async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.changing,
      );
    });
    bool res = false;
    if (newName != '') {
      res = await UserServices.instance.updateDisplayName(newName);
    }
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.normal,
      );
    });
    return res;
  }

  Future<void> resetDisplayName() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.changing,
      );
    });
    await UserServices.instance.resetDisplayName();
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.normal,
      );
    });
  }

  Future<bool> deleteAccount() async {
    await Future.delayed(Duration.zero, () {
      state = state.copy(
        newStateName: UserSettingsStateName.changing,
      );
    });
    bool res = await UserServices.instance.deleteUser();
    if (res) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserSettingsStateName.redirecting,
        );
      });
      return true;
    } else {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newStateName: UserSettingsStateName.normal,
        );
      });
      return false;
    }
  }
}
