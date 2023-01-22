import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/home/home.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/i_reloadable_page.dart';
import 'package:pokemon_battle_logger/routing/home_pages.dart';
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

    final List<Tuple2<Widget, StateNotifierProvider<StateNotifier, dynamic>>> pages = HomePages.getPages();

    final index = state.selectedPageIndicesStack.last;

    return WillPopScope(
      onWillPop: () async {
        return await ref.read(homeProvider.notifier).popPage();
      },
      child: Scaffold(
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
        body: pages[index].item1,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases_outlined),
              label: 'new',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department),
              label: 'popular',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'user',
            ),
          ],
          currentIndex: index,
          backgroundColor: Colors.red.shade900,
          selectedItemColor: Colors.red.shade50,
          unselectedItemColor: Colors.black.withOpacity(0.5),
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          onTap: (newIndex) {
            if (index == newIndex && ref.watch(pages[index].item2.notifier) is IReloadablePage) {
              (ref.read(pages[index].item2.notifier) as IReloadablePage).reload(null);
            } else {
              ref.read(homeProvider.notifier).changePage(newIndex);
            }
          },
        ),
      ),
    );
  }
}
