import 'package:pokemon_battle_logger/notifier_args/i_notifier_arg.dart';

class PokemonEditNotifierArg implements INotifierArg {
  String get uid => _uid;
  final String _uid;

  String get userName => _userName;
  final String _userName;

  int get index => _index;
  final int _index;

  const PokemonEditNotifierArg({
    required String uid,
    required String userName,
    required int index,
  })  : _uid = uid,
        _userName = userName,
        _index = index;
}
