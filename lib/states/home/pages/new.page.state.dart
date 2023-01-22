class NewPageState {
  final bool isReloading;

  const NewPageState({required this.isReloading});

  NewPageState copy({bool? newIsReloading}) {
    return NewPageState(
      isReloading: newIsReloading ?? isReloading,
    );
  }
}
