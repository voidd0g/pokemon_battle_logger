class UserSettingsState {
  final UserSettingsStateName stateName;
  const UserSettingsState({required this.stateName});

  UserSettingsState copy({UserSettingsStateName? newStateName}) {
    return UserSettingsState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum UserSettingsStateName {
  notInitialized,
  initializing,
  normal,
  redirecting,
  changing,
}
