import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/user.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon/pokemon.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/user/user_settings.notifier.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';
import 'package:pokemon_battle_logger/states/home/pages/user.page.state.dart';
import 'package:pokemon_battle_logger/widgets/button.dart';
import 'package:pokemon_battle_logger/widgets/plain_text.dart';

class UserPageView extends ConsumerWidget {
  const UserPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageProvider);
    if (state.stateName == UserPageStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(userPageProvider.notifier).initialize();
      });
    }

    Widget screen;
    switch (state.stateName) {
      case UserPageStateName.notInitialized:
      case UserPageStateName.initializing:
      case UserPageStateName.signingIn:
      case UserPageStateName.signingOut:
        screen = SpinKitChasingDots(
          color: ThemeColors.spinnerColor,
        );
        break;
      case UserPageStateName.normal:
        if (UserServices.instance.currentUser != null) {
          final userCard = Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: UserServices.instance.currentUser!.iconPath != null
                        ? CachedNetworkImage(
                            imageUrl: UserServices.instance.currentUser!.iconPath!,
                            placeholder: (context, path) => SpinKitChasingDots(
                              color: ThemeColors.spinnerColor,
                            ),
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(UserServices.instance.currentUser!.displayName[0]),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlainText(
                  text: UserServices.instance.currentUser!.displayName,
                  weight: FontWeight.bold,
                  size: 20.0,
                ),
              ),
            ],
          );
          final buttons = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Button(
                  onPressed: () async {
                    await ref.read(pokemonProvider.notifier).reset();
                    await Future.delayed(Duration.zero, () async {
                      await Navigator.of(context).pushNamed(AppRouting.pokemon);
                    });
                    await ref.read(userPageProvider.notifier).reset();
                  },
                  buttonHeight: 50.0,
                  radius: 25.0,
                  icon: Icons.warning_amber_outlined,
                  text: 'ポケモンをチェック',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Button(
                  onPressed: () async {},
                  buttonHeight: 50.0,
                  radius: 25.0,
                  icon: Icons.info_outline,
                  text: 'パーティをチェック',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Button(
                  onPressed: () async {
                    await ref.read(userSettingsProvider.notifier).reset();
                    await Future.delayed(Duration.zero, () async {
                      await Navigator.of(context).pushNamed(AppRouting.user);
                    });
                    await ref.read(userPageProvider.notifier).reset();
                  },
                  buttonHeight: 50.0,
                  radius: 25.0,
                  icon: Icons.settings,
                  text: 'ユーザー設定',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Button(
                  onPressed: () async {
                    bool res = await Future.delayed(Duration.zero, () async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const PlainText(
                            text: 'サインアウト',
                            weight: FontWeight.bold,
                            size: 16.0,
                          ),
                          content: const PlainText(
                            text: 'サインアウトしますか',
                            weight: FontWeight.normal,
                            size: 16.0,
                          ),
                          actions: [
                            Button(
                              onPressed: () async {
                                await Future.delayed(Duration.zero, () async {
                                  Navigator.of(context).pop(true);
                                });
                              },
                              buttonHeight: 40.0,
                              radius: 20.0,
                              highlighted: true,
                              icon: Icons.logout,
                              text: 'はい',
                            ),
                            Button(
                              onPressed: () async {
                                await Future.delayed(Duration.zero, () async {
                                  Navigator.of(context).pop(false);
                                });
                              },
                              buttonHeight: 40.0,
                              radius: 20.0,
                              icon: Icons.cancel_outlined,
                              text: 'いいえ',
                            )
                          ],
                        ),
                      );
                    });
                    if (res) {
                      await ref.read(userPageProvider.notifier).signOut();
                    }
                  },
                  buttonHeight: 50.0,
                  radius: 25.0,
                  highlighted: true,
                  icon: Icons.logout,
                  text: 'サインアウト',
                ),
              ],
            ),
          );
          screen = ListView(
            children: [
              Column(
                children: [
                  userCard,
                  buttons,
                ],
              ),
            ],
          );
        } else {
          screen = Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                onPressed: () async {
                  bool res = await ref.read(userPageProvider.notifier).trySignIn();
                  if (!res) {
                    Future.delayed(Duration.zero, () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const PlainText(
                            text: 'サインインエラー',
                            weight: FontWeight.bold,
                            size: 16.0,
                          ),
                          content: const PlainText(
                            text: 'Googleアカウントサインインに失敗',
                            weight: FontWeight.normal,
                            size: 16.0,
                          ),
                          actions: [
                            Button(
                              onPressed: () async {
                                await Future.delayed(Duration.zero, () async {
                                  Navigator.of(context).pop();
                                });
                              },
                              buttonHeight: 40.0,
                              radius: 20.0,
                              highlighted: true,
                              icon: Icons.check,
                              text: 'OK',
                            )
                          ],
                        ),
                      );
                    });
                  }
                },
                buttonHeight: 50.0,
                radius: 25.0,
                icon: Icons.login,
                text: 'サインイン',
              ),
            ),
          );
        }
        break;
    }

    return screen;
  }
}
