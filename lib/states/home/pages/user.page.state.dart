class UserPageState {
  final UserPageStateName stateName;

  const UserPageState({required this.stateName});

  UserPageState copy({UserPageStateName? newStateName}) {
    return UserPageState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum UserPageStateName {
  notInitialized,
  initializing,
  normal,
  reloading,
  signingIn,
  signingOut,
}
