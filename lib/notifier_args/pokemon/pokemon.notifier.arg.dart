import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';

class PokemonNotifierArg implements INotifierArg {
  String get uid => _uid;
  final String _uid;

  String get userName => _userName;
  final String _userName;

  const PokemonNotifierArg({
    required String uid,
    required String userName,
  })  : _uid = uid,
        _userName = userName;
}
