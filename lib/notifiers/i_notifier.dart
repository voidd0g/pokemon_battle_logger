import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';

abstract class INotifier {
  Future<void> initialize({INotifierArg? arg});
  Future<void> reset();
}
