import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/home.page.notifier.dart';

class HomePageView extends ConsumerWidget {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageProvider);
    return state.isReloading
        ? SpinKitChasingDots(
            color: Colors.red.shade300,
          )
        : const Text('HomePage');
  }
}
