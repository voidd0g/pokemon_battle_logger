import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/new.page.notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/new.page.state.dart';

class NewPageView extends ConsumerWidget {
  const NewPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newPageProvider);
    if (state.stateName == NewPageStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(newPageProvider.notifier).initialize();
      });
    }

    Widget screen;
    switch (state.stateName) {
      case NewPageStateName.notInitialized:
      case NewPageStateName.initializing:
      case NewPageStateName.reloading:
        screen = SpinKitChasingDots(
          color: Colors.red.shade300,
        );
        break;
      case NewPageStateName.normal:
        screen = const Text('NewPage');
        break;
    }

    return screen;
  }
}
