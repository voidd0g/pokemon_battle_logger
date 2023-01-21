class HomePageState {
  final bool isReloading;

  const HomePageState({required this.isReloading});

  HomePageState copy({bool? newIsReloading}) {
    return HomePageState(
      isReloading: newIsReloading ?? isReloading,
    );
  }
}
