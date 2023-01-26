import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/popular.page.notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/popular.page.state.dart';

class PopularPageView extends ConsumerWidget {
  const PopularPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(popularPageProvider);
    if (state.stateName == PopularPageStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(popularPageProvider.notifier).initialize();
      });
    }

    Widget screen;
    switch (state.stateName) {
      case PopularPageStateName.notInitialized:
      case PopularPageStateName.initializing:
      case PopularPageStateName.reloading:
        screen = SpinKitChasingDots(
          color: Colors.red.shade300,
        );
        break;
      case PopularPageStateName.normal:
        screen = const Text('PopularPage');
        break;
    }

    return screen;
  }
}
