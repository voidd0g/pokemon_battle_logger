import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pokemon_battle_logger/firebase_options.dart';

class FirebaseUtil {
  static final FirebaseUtil _instance = FirebaseUtil._();
  static FirebaseUtil get instance => _instance;
  FirebaseAuth get authInstance => FirebaseAuth.instance;
  FirebaseFirestore get firestoreInstance => FirebaseFirestore.instance;
  FirebaseStorage get storageInstance => FirebaseStorage.instance;
  bool _isInitialized;

  FirebaseUtil._() : _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
    }
    return;
  }
}
