import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/home/home.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/home.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/search.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/user.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/views/home/pages/home.page.view.dart';
import 'package:pokemon_battle_logger/views/home/pages/search.page.view.dart';
import 'package:pokemon_battle_logger/views/home/pages/user.page.view.dart';
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

    final List<Tuple2<Widget, StateNotifierProvider<StateNotifier, dynamic>>> pages = [
      Tuple2<Widget, StateNotifierProvider>(const SearchPageView(), searchPageProvider),
      Tuple2<Widget, StateNotifierProvider>(const HomePageView(), homePageProvider),
      Tuple2<Widget, StateNotifierProvider>(const UserPageView(), userPageProvider),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20.0,
            ),
            Text(
              'Pokemon Battle Logger',
              style: TextStyle(
                fontFamily: 'NoteSansJapanese',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: Colors.red.shade900,
              ),
            )
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red.shade100,
        elevation: 0.0,
      ),
      body: pages[state.selectedPageIndex].item1,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'user',
          ),
        ],
        currentIndex: state.selectedPageIndex,
        backgroundColor: Colors.red.shade900,
        selectedItemColor: Colors.red.shade50,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        onTap: (newIndex) {
          if (state.selectedPageIndex == newIndex && ref.watch(pages[state.selectedPageIndex].item2.notifier) is IReloadablePage) {
            (ref.read(pages[state.selectedPageIndex].item2.notifier) as IReloadablePage).reload();
          }
          ref.read(homeProvider.notifier).changePage(newIndex);
        },
      ),
    );
  }
}
