class SearchPageState {
  final bool isReloading;

  const SearchPageState({required this.isReloading});

  SearchPageState copy({bool? newIsReloading}) {
    return SearchPageState(
      isReloading: newIsReloading ?? isReloading,
    );
  }
}
