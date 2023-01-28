class UserState {
  final UserStateName stateName;
  const UserState({required this.stateName});

  UserState copy({UserStateName? newStateName}) {
    return UserState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum UserStateName {
  notInitialized,
  initializing,
  normal,
  redirecting,
  changing,
}
