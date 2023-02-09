import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemon_battle_logger/models/user.dart';
import 'package:pokemon_battle_logger/utils/firebase_util.dart';
import 'package:pokemon_battle_logger/utils/text_field_util.dart';

class UserServices {
  static final UserServices _instance = UserServices._();

  static UserServices get instance => _instance;

  UserServices._();

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> checkCacheSignedIn() async {
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
    if (auth.currentUser == null) {
      return;
    }
    final DocumentSnapshot<Map<String, dynamic>> userDoc;
    try {
      userDoc = await store.collection('users').doc(auth.currentUser!.uid).get();
    } on FirebaseException {
      return;
    }
    if (userDoc.exists) {
      _currentUser = User.fromMap(userDoc.data()!);
      return;
    }
    final displayName = TextFieldUtil.limitLength(source: auth.currentUser!.displayName ?? auth.currentUser!.uid, maxLength: 30);
    final User userToWrite = User(
      uid: auth.currentUser!.uid,
      displayName: displayName!,
      iconPath: auth.currentUser?.photoURL,
    );
    try {
      await store.collection('users').doc(auth.currentUser!.uid).set(_currentUser!.toMap());
    } on FirebaseException {
      return;
    }

    _currentUser = userToWrite;
    return;
  }

  Future<User?> signInWithGoogle() async {
    if (_currentUser != null) {
      return _currentUser!;
    }

    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return null;
    }
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      await auth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException {
      return null;
    }

    if (auth.currentUser == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc;
    try {
      userDoc = await store.collection('users').doc(auth.currentUser!.uid).get();
    } on FirebaseException {
      return null;
    }

    if (userDoc.exists) {
      _currentUser = User.fromMap(userDoc.data()!);
      return _currentUser!;
    }

    final displayName = TextFieldUtil.limitLength(source: auth.currentUser!.displayName ?? auth.currentUser!.uid, maxLength: 30);
    final User userToWrite = User(
      uid: auth.currentUser!.uid,
      displayName: displayName!,
      iconPath: auth.currentUser?.photoURL,
    );

    try {
      await store.collection('users').doc(auth.currentUser!.uid).set(userToWrite.toMap());
    } on FirebaseException {
      return null;
    }

    _currentUser = userToWrite;
    return _currentUser!;
  }

  Future<void> signOutFromGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    await googleSignIn.signOut();
    await auth.signOut();
    _currentUser = null;
  }

  Future<String?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<bool> updateIcon(String imagePath) async {
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
    final FirebaseStorage storage = FirebaseUtil.instance.storageInstance;

    File file = File(imagePath);

    if (!file.existsSync() || auth.currentUser == null || _currentUser == null) {
      return false;
    }

    try {
      await storage.ref('users/${_currentUser!.uid}/icon').putFile(file);
    } on FirebaseException {
      return false;
    }

    final String imageUrl;
    try {
      imageUrl = await storage.ref('users/${_currentUser!.uid}/icon').getDownloadURL();
    } on FirebaseException {
      return false;
    }

    try {
      await store.collection('users').doc(auth.currentUser!.uid).update({User.iconPathField: imageUrl});
    } on FirebaseException {
      return false;
    }
    _currentUser = _currentUser!.copy(newIconPath: imageUrl);
    return true;
  }

  Future<void> deleteIcon() async {
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;
    final FirebaseStorage storage = FirebaseUtil.instance.storageInstance;

    if (auth.currentUser == null || _currentUser == null) {
      return;
    }
    try {
      await store.collection('users').doc(auth.currentUser!.uid).update({User.iconPathField: null});
    } on FirebaseException {
      return;
    }
    _currentUser = User(
      uid: _currentUser!.uid,
      displayName: _currentUser!.displayName,
      iconPath: null,
    );
    try {
      await storage.ref('users/${_currentUser!.uid}/icon').delete();
    } on FirebaseException {
      return;
    }
  }

  Future<void> resetIcon() async {
    await deleteIcon();
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    if (auth.currentUser == null || _currentUser == null) {
      return;
    }

    if (auth.currentUser!.photoURL == null) {
      return;
    }

    try {
      await store.collection('users').doc(auth.currentUser!.uid).update({User.iconPathField: auth.currentUser!.photoURL});
    } on FirebaseException {
      return;
    }
    _currentUser = _currentUser!.copy(newIconPath: auth.currentUser!.photoURL);
  }

  Future<bool> updateDisplayName(String newName) async {
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    if (auth.currentUser == null || _currentUser == null) {
      return false;
    }
    final displayName = TextFieldUtil.limitLength(source: newName, maxLength: 30);
    try {
      await store.collection('users').doc(auth.currentUser!.uid).update({User.displayNameField: displayName});
    } on FirebaseException {
      return false;
    }
    _currentUser = _currentUser!.copy(newDisplayName: displayName);
    return true;
  }

  Future<void> resetDisplayName() async {
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    if (auth.currentUser == null || _currentUser == null) {
      return;
    }
    if (auth.currentUser!.displayName == null) {
      return;
    }
    final displayName = TextFieldUtil.limitLength(source: auth.currentUser!.displayName!, maxLength: 30);
    try {
      await store.collection('users').doc(auth.currentUser!.uid).update({User.displayNameField: displayName});
    } on FirebaseException {
      return;
    }
    _currentUser = _currentUser!.copy(newDisplayName: displayName);
  }

  Future<bool> deleteUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final firebase_auth.FirebaseAuth auth = FirebaseUtil.instance.authInstance;
    final FirebaseFirestore store = FirebaseUtil.instance.firestoreInstance;

    if (auth.currentUser == null) {
      return false;
    }

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return false;
    }
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      await auth.currentUser!.reauthenticateWithCredential(credential);
    } on firebase_auth.FirebaseAuthException {
      return false;
    }

    await deleteIcon();
    try {
      await store.collection('users').doc(auth.currentUser!.uid).delete();
    } on FirebaseException {
      return false;
    }

    await auth.currentUser!.delete();
    _currentUser = null;

    await googleSignIn.signOut();

    return true;
  }
}
