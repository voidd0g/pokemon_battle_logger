import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemon_battle_logger/models/user.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';
import 'package:pokemon_battle_logger/utils/text_field_util.dart';

class UserServices {
  static final UserServices _instance = UserServices._();

  static UserServices get instance => _instance;

  UserServices._();

  User? currentUser;

  Future<void> checkCacheSignedIn() async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
      if (auth.currentUser != null) {
        final userDoc = await store.collection('users').doc(auth.currentUser!.uid).get();
        if (!userDoc.exists) {
          final displayName = TextFieldUtil.limitLength(source: auth.currentUser!.displayName?.substring(0, 30) ?? auth.currentUser!.uid.substring(0, 30), maxLength: 30);
          currentUser = User(
            uid: auth.currentUser!.uid,
            displayName: displayName!,
            iconPath: auth.currentUser?.photoURL,
          );
          await store.collection('users').doc(auth.currentUser!.uid).set(currentUser!.toMap());
        } else {
          currentUser = User.fromMap(userDoc.data()!);
        }
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

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
            final displayName = TextFieldUtil.limitLength(source: auth.currentUser!.displayName?.substring(0, 30) ?? auth.currentUser!.uid.substring(0, 30), maxLength: 30);
            currentUser = User(
              uid: auth.currentUser!.uid,
              displayName: displayName!,
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

  Future<String?> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateIcon(String imagePath) async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
      final FirebaseStorage storage = FirebaseUtil.instance.storageInstance;

      File file = File(imagePath);

      if (file.existsSync() && auth.currentUser != null && currentUser != null) {
        await storage.ref('users/${currentUser!.uid}/icon').putFile(file);
        final String imageUrl = await storage.ref('users/${currentUser!.uid}/icon').getDownloadURL();
        await store.collection('users').doc(auth.currentUser!.uid).update({User.iconPathField: imageUrl});
        currentUser = currentUser!.copy(newIconPath: imageUrl);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> deleteIcon() async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
      final FirebaseStorage storage = FirebaseUtil.instance.storageInstance;

      if (auth.currentUser != null && currentUser != null) {
        await storage.ref('users/${currentUser!.uid}/icon').delete();
        await store.collection('users').doc(auth.currentUser!.uid).update({User.iconPathField: null});
        currentUser = User(
          uid: currentUser!.uid,
          displayName: currentUser!.displayName,
          iconPath: null,
        );
        return;
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  Future<void> resetIcon() async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

      if (auth.currentUser != null && currentUser != null) {
        await deleteIcon();
        if (auth.currentUser!.photoURL != null) {
          await store.collection('users').doc(auth.currentUser!.uid).update({User.iconPathField: auth.currentUser!.photoURL});
          currentUser = currentUser!.copy(newIconPath: auth.currentUser!.photoURL);
        }
        return;
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  Future<bool> updateDisplayName(String newName) async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

      if (auth.currentUser != null && currentUser != null) {
        final displayName = TextFieldUtil.limitLength(source: newName, maxLength: 30);
        await store.collection('users').doc(auth.currentUser!.uid).update({User.displayNameField: displayName});
        currentUser = currentUser!.copy(newDisplayName: displayName);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> resetDisplayName() async {
    try {
      final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
      final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

      if (auth.currentUser != null && currentUser != null) {
        if (auth.currentUser!.displayName != null) {
          final displayName = TextFieldUtil.limitLength(source: auth.currentUser!.displayName!, maxLength: 30);
          await store.collection('users').doc(auth.currentUser!.uid).update({User.displayNameField: displayName});
          currentUser = currentUser!.copy(newDisplayName: displayName);
        }
        return;
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  Future<void> deleteUser() async {
    await GoogleSignIn().signOut();
    final FirebaseAuth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
    await deleteIcon();
    await store.collection('users').doc(auth.currentUser!.uid).delete();
    await auth.currentUser!.delete();
    currentUser = null;
  }
}
