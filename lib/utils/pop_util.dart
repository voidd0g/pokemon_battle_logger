import 'package:flutter/cupertino.dart';

class PopUtil {
  static Future<void> popOrPushNamed({required BuildContext context, required String name}) async {
    if (Navigator.of(context).canPop()) {
      await Future.delayed(Duration.zero, () async {
        Navigator.of(context).pop();
      });
    } else {
      await Future.delayed(Duration.zero, () async {
        Navigator.of(context).pushReplacementNamed(name);
      });
    }
  }
}
