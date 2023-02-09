class User {
  final String uid;
  final String displayName;
  final String? iconPath;

  static const String uidField = 'uid';
  static const String displayNameField = 'display_name';
  static const String iconPathField = 'icon_path';

  const User({
    required this.uid,
    required this.displayName,
    required this.iconPath,
  });

  User copy({
    String? newUid,
    String? newDisplayName,
    String? newIconPath,
  }) {
    return User(
      uid: newUid ?? uid,
      displayName: newDisplayName ?? displayName,
      iconPath: newIconPath ?? iconPath,
    );
  }

  User.fromMap(Map<String, dynamic> data)
      : uid = data[uidField],
        displayName = data[displayNameField],
        iconPath = data[iconPathField];

  Map<String, dynamic> toMap() {
    return {
      uidField: uid,
      displayNameField: displayName,
      iconPathField: iconPath,
    };
  }
}
