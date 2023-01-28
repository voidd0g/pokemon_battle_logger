class HomeState {
  final HomeStateName stateName;
  final List<int> selectedPageIndicesStack;
  const HomeState({required this.stateName, required this.selectedPageIndicesStack});

  HomeState copy({HomeStateName? newStateName, List<int>? newSelectedPageIndicesStack}) {
    return HomeState(
      stateName: newStateName ?? stateName,
      selectedPageIndicesStack: newSelectedPageIndicesStack ?? selectedPageIndicesStack,
    );
  }
}

enum HomeStateName {
  notInitialized,
  initializing,
  normal,
}
