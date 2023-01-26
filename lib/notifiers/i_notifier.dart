abstract class INotifier {
  Future<void> initialize();
  Future<void> reload(IReloadableArg? arg);
}

abstract class IReloadableArg {}
