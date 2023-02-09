import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon_battle_logger/models/pokemon.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

class PokemonServices {
  static final PokemonServices _instance = PokemonServices._();

  static PokemonServices get instance => _instance;

  PokemonServices._();

  List<Pokemon>? _pokemons;
  List<Pokemon>? get pokemons => _pokemons;

  static const int listQueryLimit = 50;

  Future<void> getAllAvailablePokemons() async {
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
    List<Pokemon> newPokemons = [];
    DocumentSnapshot<Map<String, dynamic>>? prevDoc;
    while (true) {
      final QuerySnapshot<Map<String, dynamic>> pokemonCollection;
      try {
        if (prevDoc == null) {
          pokemonCollection = await store.collection('pokemons').limit(listQueryLimit).get();
        } else {
          pokemonCollection = await store.collection('pokemons').startAfterDocument(prevDoc).limit(listQueryLimit).get();
        }
      } on FirebaseException {
        return;
      }

      final pokemonDocs = pokemonCollection.docs;
      newPokemons.addAll(pokemonDocs.map((value) => Pokemon.fromMap(value.data())));
      if (pokemonDocs.length < listQueryLimit) {
        break;
      }
      prevDoc = await pokemonDocs.last.reference.get();
    }

    _pokemons = newPokemons;
  }
}
