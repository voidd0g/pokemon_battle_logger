class PopularPageState {
  final PopularPageStateName stateName;

  const PopularPageState({required this.stateName});

  PopularPageState copy({PopularPageStateName? newStateName}) {
    return PopularPageState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum PopularPageStateName {
  notInitialized,
  initializing,
  normal,
}
