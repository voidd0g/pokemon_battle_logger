import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/user.page.notifier.dart';

class UserPageView extends ConsumerWidget {
  const UserPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageProvider);
    return state.isReloading
        ? SpinKitChasingDots(
            color: Colors.red.shade300,
          )
        : const Text('UserPage');
  }
}
