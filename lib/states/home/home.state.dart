class HomeState {
  final int selectedPageIndex;
  const HomeState({required this.selectedPageIndex});

  HomeState copy({int? newSelectedPageIndex}) {
    return HomeState(
      selectedPageIndex: newSelectedPageIndex ?? selectedPageIndex,
    );
  }
}
