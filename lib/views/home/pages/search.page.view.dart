import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/search.page.notifier.dart';
import 'package:pokemon_battle_logger/states/home/pages/search.page.state.dart';

class SearchPageView extends ConsumerWidget {
  const SearchPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchPageProvider);
    if (state.stateName == SearchPageStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(searchPageProvider.notifier).initialize();
      });
    }

    Widget screen;
    switch (state.stateName) {
      case SearchPageStateName.notInitialized:
      case SearchPageStateName.initializing:
        screen = SpinKitChasingDots(
          color: ThemeColors.spinnerColor,
        );
        break;
      case SearchPageStateName.normal:
        screen = const Text('SearchPage');
        break;
    }

    return screen;
  }
}
