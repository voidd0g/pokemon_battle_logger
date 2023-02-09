import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon_battle_logger/models/pokemon_trained.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

class PokemonTrainedServices {
  static final PokemonTrainedServices _instance = PokemonTrainedServices._();

  static PokemonTrainedServices get instance => _instance;

  PokemonTrainedServices._() : _pokemonsTrainedByUsers = {};

  Map<String, List<PokemonTrained?>?> _pokemonsTrainedByUsers;
  Map<String, List<PokemonTrained?>?> get pokemonsTrainedByUsers => _pokemonsTrainedByUsers;

  static const int minIndex = 1;
  static const int maxIndex = 12;

  Future<void> getAllAvailablePokemonsTrained({
    required String uid,
  }) async {
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    List<PokemonTrained?> newPokemonsTrained = List<PokemonTrained?>.filled(maxIndex - minIndex + 1, null);

    final CollectionReference<Map<String, dynamic>> collection = store.collection('users').doc(uid).collection('pokemons');
    List<Future<DocumentSnapshot<Map<String, dynamic>>>?> docWaits = List<Future<DocumentSnapshot<Map<String, dynamic>>>?>.filled(maxIndex - minIndex + 1, null);

    for (int index = minIndex; index <= maxIndex; index++) {
      try {
        docWaits[index - minIndex] = collection.doc(index.toString()).get();
      } on FirebaseException {
        return;
      }
    }

    for (int index = minIndex; index <= maxIndex; index++) {
      final DocumentSnapshot<Map<String, dynamic>> doc;
      try {
        doc = await docWaits[index - minIndex]!;
      } on FirebaseException {
        return;
      }

      if (!doc.exists) {
        continue;
      }

      newPokemonsTrained[index - minIndex] = PokemonTrained.fromMap(doc.data()!);
    }

    Map<String, List<PokemonTrained?>?> newPokemonsTrainedByUsers = _pokemonsTrainedByUsers;
    newPokemonsTrainedByUsers[uid] = newPokemonsTrained;
    _pokemonsTrainedByUsers = newPokemonsTrainedByUsers;
  }

  Future<void> updatePokemonTrained({
    required PokemonTrained data,
    required int index,
  }) async {
    final FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    if (auth.currentUser == null || index < minIndex || maxIndex < index) {
      return;
    }

    try {
      store.collection('users').doc(auth.currentUser!.uid).collection('pokemons').doc(index.toString()).set(data.toMap());
    } on FirebaseException {
      return;
    }

    List<PokemonTrained?> updatedPokemonsTrained = [..._pokemonsTrainedByUsers[auth.currentUser!.uid] ?? []];
    updatedPokemonsTrained[index] = data;

    Map<String, List<PokemonTrained?>?> newPokemonsTrainedByUsers = _pokemonsTrainedByUsers;
    newPokemonsTrainedByUsers[auth.currentUser!.uid] = updatedPokemonsTrained;
    _pokemonsTrainedByUsers = newPokemonsTrainedByUsers;
  }

  Future<void> deletePokemonTrained({
    required int index,
  }) async {
    final FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    if (auth.currentUser == null || index < minIndex || maxIndex < index) {
      return;
    }

    try {
      store.collection('users').doc(auth.currentUser!.uid).collection('pokemons').doc(index.toString()).delete();
    } on FirebaseException {
      return;
    }

    List<PokemonTrained?> updatedPokemonsTrained = [..._pokemonsTrainedByUsers[auth.currentUser!.uid] ?? []];
    updatedPokemonsTrained[index] = null;

    Map<String, List<PokemonTrained?>?> newPokemonsTrainedByUsers = _pokemonsTrainedByUsers;
    newPokemonsTrainedByUsers[auth.currentUser!.uid] = updatedPokemonsTrained;
    _pokemonsTrainedByUsers = newPokemonsTrainedByUsers;
  }
}
