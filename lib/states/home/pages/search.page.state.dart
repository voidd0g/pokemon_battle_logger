class SearchPageState {
  final SearchPageStateName stateName;

  const SearchPageState({required this.stateName});

  SearchPageState copy({SearchPageStateName? newStateName}) {
    return SearchPageState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum SearchPageStateName {
  notInitialized,
  initializing,
  normal,
}
