class HomeState {
  final List<int> selectedPageIndicesStack;
  const HomeState({required this.selectedPageIndicesStack});

  HomeState copy({List<int>? newSelectedPageIndicesStack}) {
    return HomeState(
      selectedPageIndicesStack: newSelectedPageIndicesStack ?? selectedPageIndicesStack,
    );
  }
}
