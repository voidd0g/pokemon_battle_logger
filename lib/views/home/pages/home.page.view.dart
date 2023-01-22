import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/notifiers/home/home.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/home.page.notifier.dart';
import 'package:pokemon_battle_logger/routing/home_pages.dart';

class HomePageView extends ConsumerWidget {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  static const buttonHeight = 75.0;

  Widget _button({required bool left, required WidgetRef ref, required String text, required IconData icon, required int jumpIndex}) {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(homeProvider.notifier).changePage(jumpIndex);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return Colors.red.shade700;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return Colors.red.shade50;
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          return Colors.red.shade50.withOpacity(0.2);
        }),
        shape: MaterialStateProperty.resolveWith((states) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          );
        }),
      ),
      child: SizedBox(
        height: buttonHeight,
        child: Stack(
          textDirection: left ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                widthFactor: 1.0,
                child: Icon(left ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  Text(text),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageProvider);

    final buttons = [
      _button(
        left: true,
        ref: ref,
        text: '新たなログを発見する!!',
        icon: Icons.new_releases_outlined,
        jumpIndex: HomePages.newPageIndex,
      ),
      _button(
        left: true,
        ref: ref,
        text: '人気のパーティを見てみる!!',
        icon: Icons.local_fire_department,
        jumpIndex: HomePages.popularPageIndex,
      ),
      _button(
        left: false,
        ref: ref,
        text: '探してみる!!',
        icon: Icons.search,
        jumpIndex: HomePages.searchPageIndex,
      ),
      _button(
        left: false,
        ref: ref,
        text: 'マイページに行く!!',
        icon: Icons.person_outline,
        jumpIndex: HomePages.userPageIndex,
      ),
    ];

    return state.isReloading
        ? SpinKitChasingDots(
            color: Colors.red.shade300,
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: (buttonHeight + 20.0) * buttons.length,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buttons,
              ),
            ),
          );
  }
}
