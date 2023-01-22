class PopularPageState {
  final bool isReloading;

  const PopularPageState({required this.isReloading});

  PopularPageState copy({bool? newIsReloading}) {
    return PopularPageState(
      isReloading: newIsReloading ?? isReloading,
    );
  }
}
