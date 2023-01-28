abstract class INotifier {
  Future<void> initialize({INotifierArg? arg});
  Future<void> reset();
}

abstract class INotifierArg {}
