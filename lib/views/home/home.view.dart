import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifiers/home/home.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/i_notifier.dart';
import 'package:pokemon_battle_logger/routing/home_pages.dart';
import 'package:pokemon_battle_logger/states/home/home.state.dart';
import 'package:pokemon_battle_logger/widgets/app_frame.dart';
import 'package:tuple/tuple.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    if (state.stateName == HomeStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(homeProvider.notifier).initialize();
      });
    }

    final List<Tuple2<Widget, StateNotifierProvider<StateNotifier, dynamic>>> pages = HomePages.getPages();

    final index = state.selectedPageIndicesStack.last;

    Widget screen;
    switch (state.stateName) {
      case HomeStateName.notInitialized:
      case HomeStateName.initializing:
        screen = AppFrame(
          onWillPop: () async => false,
          bottomNavigationBar: Container(
            height: 54.0,
            color: ThemeColors.bottomBarBackgroundColor,
          ),
          child: SpinKitChasingDots(
            color: ThemeColors.spinnerColor,
          ),
        );
        break;
      case HomeStateName.normal:
        screen = AppFrame(
          onWillPop: () async => ref.read(homeProvider.notifier).popPage(),
          bottomNavigationBar: SizedBox(
            height: 54.0,
            child: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.new_releases_outlined),
                  label: '最新',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department),
                  label: '人気',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'ホーム',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'さがす',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'ユーザー',
                ),
              ],
              currentIndex: index,
              backgroundColor: ThemeColors.bottomBarBackgroundColor,
              selectedItemColor: ThemeColors.bottomBarSelectedColor,
              unselectedItemColor: ThemeColors.bottomBarUnselectedColor,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(
                fontFamily: 'MPLUSRounded1c',
                fontWeight: FontWeight.w600,
                color: ThemeColors.bottomBarSelectedColor,
                fontSize: 12.0,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'MPLUSRounded1c',
                fontWeight: FontWeight.w400,
                color: ThemeColors.bottomBarUnselectedColor,
                fontSize: 12.0,
              ),
              elevation: 0.0,
              onTap: (newIndex) {
                if (index == newIndex && ref.watch(pages[index].item2.notifier) is INotifier) {
                  (ref.read(pages[index].item2.notifier) as INotifier).reset();
                } else {
                  ref.read(homeProvider.notifier).changePage(newIndex);
                }
              },
            ),
          ),
          child: pages[index].item1,
        );
        break;
    }

    return screen;
  }
}
