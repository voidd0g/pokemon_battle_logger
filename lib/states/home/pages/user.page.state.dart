class UserPageState {
  final bool isReloading;

  const UserPageState({required this.isReloading});

  UserPageState copy({bool? newIsReloading}) {
    return UserPageState(
      isReloading: newIsReloading ?? isReloading,
    );
  }
}
