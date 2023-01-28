class HomePageState {
  final HomePageStateName stateName;

  const HomePageState({required this.stateName});

  HomePageState copy({HomePageStateName? newStateName}) {
    return HomePageState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum HomePageStateName {
  notInitialized,
  initializing,
  normal,
}
