import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifiers/home/home.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/home.page.notifier.dart';
import 'package:pokemon_battle_logger/routing/home_pages.dart';
import 'package:pokemon_battle_logger/states/home/pages/home.page.state.dart';
import 'package:pokemon_battle_logger/widgets/button.dart';

class HomePageView extends ConsumerWidget {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  static const buttonHeight = 75.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageProvider);
    if (state.stateName == HomePageStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(homePageProvider.notifier).initialize();
      });
    }

    final List<Widget> buttons = [
      Button(
        onPressed: () async {
          await ref.read(homeProvider.notifier).changePage(HomePages.newPageIndex);
        },
        buttonHeight: buttonHeight,
        prefix: const Icon(Icons.arrow_back_ios_new),
        radius: 100.0,
        icon: Icons.new_releases_outlined,
        text: '新たなログを発見する!!',
      ),
      const SizedBox(
        height: 20.0,
      ),
      Button(
        onPressed: () async {
          await ref.read(homeProvider.notifier).changePage(HomePages.popularPageIndex);
        },
        buttonHeight: buttonHeight,
        prefix: const Icon(Icons.arrow_back_ios_new),
        radius: 100.0,
        icon: Icons.local_fire_department,
        text: '人気のパーティを見てみる!!',
      ),
      const SizedBox(
        height: 20.0,
      ),
      Button(
        onPressed: () async {
          await ref.read(homeProvider.notifier).changePage(HomePages.searchPageIndex);
        },
        buttonHeight: buttonHeight,
        suffix: const Icon(Icons.arrow_forward_ios),
        radius: 100.0,
        icon: Icons.search,
        text: '探してみる!!',
      ),
      const SizedBox(
        height: 20.0,
      ),
      Button(
        onPressed: () async {
          await ref.read(homeProvider.notifier).changePage(HomePages.userPageIndex);
        },
        buttonHeight: buttonHeight,
        suffix: const Icon(Icons.arrow_forward_ios),
        radius: 100.0,
        icon: Icons.person_outline,
        text: 'マイページに行く!!',
      ),
    ];

    Widget screen;
    switch (state.stateName) {
      case HomePageStateName.notInitialized:
      case HomePageStateName.initializing:
        screen = SpinKitChasingDots(
          color: ThemeColors.spinnerColor,
        );
        break;
      case HomePageStateName.normal:
        screen = ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: buttons,
              ),
            ),
          ],
        );
        break;
    }

    return screen;
  }
}
