class User {
  final String uid;
  final String displayName;
  final String? iconPath;

  const User({required this.uid, required this.displayName, required this.iconPath});

  User copy({String? newUid, String? newDisplayName, String? newIconPath}) {
    return User(
      uid: newUid ?? uid,
      displayName: newDisplayName ?? displayName,
      iconPath: newIconPath ?? iconPath,
    );
  }

  User.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        displayName = data['display_name'],
        iconPath = data['icon_path'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'icon_path': iconPath,
    };
  }
}
