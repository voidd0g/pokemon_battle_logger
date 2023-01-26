import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokemon_battle_logger/models/user.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';

class UserServices {
  static final UserServices _instance = UserServices._();

  static UserServices get instance => _instance;

  UserServices._();

  User? currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final FirebaseAuth.AuthCredential credential = FirebaseAuth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await auth.signInWithCredential(credential);
        if (auth.currentUser != null) {
          final userDoc = await store.collection('users').doc(auth.currentUser!.uid).get();
          if (!userDoc.exists) {
            currentUser = User(
              uid: auth.currentUser!.uid,
              displayName: auth.currentUser!.displayName ?? auth.currentUser!.uid,
              iconPath: auth.currentUser?.photoURL,
            );
            await store.collection('users').doc(auth.currentUser!.uid).set(currentUser!.toMap());
          } else {
            currentUser = User.fromMap(userDoc.data()!);
          }
          return currentUser!;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> signOutFromGoogle() async {
    await GoogleSignIn().signOut();
    final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    await auth.signOut();
    currentUser = null;
  }

  Future<void> uploadIcon(String imagePath) async {}

  Future<void> deleteIcon() async {}
}
