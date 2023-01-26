class NewPageState {
  final NewPageStateName stateName;

  const NewPageState({required this.stateName});

  NewPageState copy({NewPageStateName? newStateName}) {
    return NewPageState(
      stateName: newStateName ?? stateName,
    );
  }
}

enum NewPageStateName {
  notInitialized,
  initializing,
  normal,
  reloading,
}
