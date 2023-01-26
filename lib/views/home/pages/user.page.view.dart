import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/user.page.notifier.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/states/home/pages/user.page.state.dart';

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
      case UserPageStateName.reloading:
      case UserPageStateName.signingIn:
      case UserPageStateName.signingOut:
        screen = SpinKitChasingDots(
          color: Colors.red.shade300,
        );
        break;
      case UserPageStateName.normal:
        if (UserServices.instance.currentUser != null) {
          screen = Column(
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
                                  color: Colors.red.shade300,
                                ),
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text('no image'),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(UserServices.instance.currentUser!.displayName),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Icon(Icons.warning_amber_outlined),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('See Your Pokemons'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Icon(Icons.info_outline),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Check Your Parties'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool res = await Future.delayed(Duration.zero, () async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: const Text("Sign Out Confirm"),
                              content: const Text("Are you sure to sign out?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text("No"),
                                )
                              ],
                            ),
                          );
                        });
                        if (res) {
                          await ref.read(userPageProvider.notifier).signOut();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Icon(Icons.login),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          screen = Center(
            child: ElevatedButton(
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
                        title: const Text("Sign In Error"),
                        content: const Text("Failed to sign in with google."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          )
                        ],
                      ),
                    );
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Sign In'),
                ],
              ),
            ),
          );
        }
        break;
    }

    return screen;
  }
}
