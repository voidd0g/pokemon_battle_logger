import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifiers/user/user.notifier.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';
import 'package:pokemon_battle_logger/states/user/user.state.dart';
import 'package:pokemon_battle_logger/widgets/app_frame.dart';
import 'package:pokemon_battle_logger/widgets/button.dart';
import 'package:pokemon_battle_logger/widgets/leading_button.dart';
import 'package:pokemon_battle_logger/widgets/plain_text.dart';
import 'package:pokemon_battle_logger/widgets/text_input.dart';

class UserView extends ConsumerWidget {
  const UserView({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    if (state.stateName == UserStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(userProvider.notifier).initialize();
      });
    }
    if (state.stateName == UserStateName.redirecting) {
      if (Navigator.of(context).canPop()) {
        Future.delayed(Duration.zero, () async {
          Navigator.of(context).pop();
        });
      } else {
        Future.delayed(Duration.zero, () async {
          Navigator.of(context).pushReplacementNamed(AppRouting.home);
        });
      }
    }

    Widget screen;
    switch (state.stateName) {
      case UserStateName.notInitialized:
      case UserStateName.initializing:
      case UserStateName.redirecting:
      case UserStateName.changing:
        screen = AppFrame(
          onWillPop: () async => false,
          child: SpinKitChasingDots(
            color: ThemeColors.spinnerColor,
          ),
        );
        break;
      case UserStateName.normal:
        screen = AppFrame(
          onWillPop: () async => true,
          leading: LeadingButton(
            onPressed: () async {
              await Future.delayed(Duration.zero, () async {
                Navigator.of(context).pop();
              });
            },
            icon: Icons.arrow_back,
          ),
          child: ListView(
            children: [
              Column(
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
                  Button(
                    onPressed: () async {
                      int res = await Future.delayed(Duration.zero, () async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: const Text('アイコンの変更'),
                            content: const Text('どこから選びますか'),
                            actions: [
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(0);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                icon: Icons.storage_outlined,
                                text: 'ストレージから',
                              ),
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(1);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                icon: Icons.refresh,
                                text: 'Googleアカウントのアイコン',
                              ),
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(2);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                highlighted: true,
                                icon: Icons.delete,
                                text: 'アイコンを削除',
                              ),
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(3);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                highlighted: true,
                                icon: Icons.arrow_back_ios_new,
                                text: 'やめる',
                              )
                            ],
                          ),
                        );
                      });
                      switch (res) {
                        case 0:
                          await ref.read(userProvider.notifier).pickImageAndUpdateIcon(ImageSource.gallery);
                          break;
                        case 1:
                          await ref.read(userProvider.notifier).resetIcon();
                          break;
                        case 2:
                          await ref.read(userProvider.notifier).deleteIcon();
                          return;
                        case 3:
                          return;
                      }
                    },
                    buttonHeight: 50.0,
                    radius: 25.0,
                    icon: Icons.edit,
                    text: 'アイコンの変更',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlainText(
                      text: UserServices.instance.currentUser!.displayName,
                      weight: FontWeight.bold,
                      size: 20.0,
                    ),
                  ),
                  Button(
                    onPressed: () async {
                      final TextEditingController controller = TextEditingController();
                      controller.text = UserServices.instance.currentUser!.displayName;
                      int res = await Future.delayed(Duration.zero, () async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: const PlainText(
                              text: 'ニックネームの変更',
                              weight: FontWeight.bold,
                              size: 16.0,
                            ),
                            content: TextInput(
                              controller: controller,
                              labelText: 'ニックネーム（30文字まで）',
                              hintText: '新しいニックネーム（30文字まで）',
                            ),
                            actions: [
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(0);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                icon: Icons.edit,
                                text: '決定',
                              ),
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(1);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                icon: Icons.refresh,
                                text: 'Googleアカウントの名前',
                              ),
                              Button(
                                onPressed: () async {
                                  await Future.delayed(Duration.zero, () async {
                                    Navigator.of(context).pop(2);
                                  });
                                },
                                buttonHeight: 40.0,
                                radius: 20.0,
                                highlighted: true,
                                icon: Icons.arrow_back_ios_new,
                                text: 'やめる',
                              )
                            ],
                          ),
                        );
                      });
                      switch (res) {
                        case 0:
                          if (controller.text != UserServices.instance.currentUser!.displayName && controller.text != '') {
                            await ref.read(userProvider.notifier).updateDisplayName(controller.text);
                          }
                          break;
                        case 1:
                          await ref.read(userProvider.notifier).resetDisplayName();
                          break;
                        case 2:
                          return;
                      }
                    },
                    buttonHeight: 50.0,
                    radius: 25.0,
                    icon: Icons.edit,
                    text: 'ニックネームの変更',
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Button(
                    onPressed: () async {
                      await Future.delayed(Duration.zero, () async {
                        Navigator.of(context).pop();
                      });
                    },
                    buttonHeight: 50.0,
                    radius: 25.0,
                    highlighted: true,
                    icon: Icons.arrow_back_ios_new,
                    text: 'もどる',
                  ),
                  const SizedBox(
                    height: 200.0,
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
                              text: 'アカウントの削除',
                              weight: FontWeight.bold,
                              size: 16.0,
                            ),
                            content: const PlainText(
                              text: 'アカウントを削除しますか（Googleアカウントは消えません）',
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
                                icon: Icons.delete,
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
                      if (!res) {
                        return;
                      }
                      res = await ref.read(userProvider.notifier).deleteAccount();
                      if (res) {
                        return;
                      }
                      await Future.delayed(Duration.zero, () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: const PlainText(
                              text: '削除エラー',
                              weight: FontWeight.bold,
                              size: 16.0,
                            ),
                            content: const PlainText(
                              text: 'アカウント削除に失敗',
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
                    },
                    buttonHeight: 50.0,
                    radius: 25.0,
                    highlighted: true,
                    icon: Icons.delete,
                    text: 'アカウントの削除',
                  ),
                ],
              ),
            ],
          ),
        );
        break;
    }

    return screen;
  }
}
