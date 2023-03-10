import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon_detail/pokemon_detail.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon_edit/pokemon_edit.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon_detail/pokemon_detail.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon_edit/pokemon_edit.notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/repos/pokemon_trained.services.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';
import 'package:pokemon_battle_logger/states/pokemon_detail/pokemon_detail.state.dart';
import 'package:pokemon_battle_logger/utils/pop_util.dart';
import 'package:pokemon_battle_logger/widgets/app_frame.dart';
import 'package:pokemon_battle_logger/widgets/button.dart';
import 'package:pokemon_battle_logger/widgets/leading_button.dart';
import 'package:pokemon_battle_logger/widgets/plain_text.dart';

class PokemonDetailView extends ConsumerWidget {
  const PokemonDetailView({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonDetailProvider);
    if (state.stateName == PokemonDetailStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(pokemonDetailProvider.notifier).initialize(arg: ModalRoute.of(context)?.settings.arguments as PokemonDetailNotifierArg?);
      });
    }
    if (state.stateName == PokemonDetailStateName.redirecting) {
      Future.delayed(Duration.zero, () async {
        await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
      });
    }

    Widget screen;
    switch (state.stateName) {
      case PokemonDetailStateName.notInitialized:
      case PokemonDetailStateName.initializing:
      case PokemonDetailStateName.redirecting:
        screen = AppFrame(
          onWillPop: () async => false,
          title: '????????????',
          child: SpinKitChasingDots(
            color: ThemeColors.spinnerColor,
          ),
        );
        break;
      case PokemonDetailStateName.normal:
        screen = AppFrame(
          onWillPop: () async => true,
          title: '????????????',
          leading: LeadingButton(
            onPressed: () async {
              await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
            },
            icon: Icons.arrow_back,
          ),
          child: ListView(
            children: [
              PlainText(
                text: '${state.arg!.userName}???${state.arg!.index + 1}?????????????????????',
                weight: FontWeight.normal,
                size: 25,
              ),
              ...PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index] != null
                  ? [
                      Center(
                        child: PlainText(
                          text: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.nickname,
                          weight: FontWeight.normal,
                          size: 25,
                        ),
                      ),
                      Center(
                        child: PlainText(
                          text: PokemonServices.instance.pokemons!
                              .where((element) =>
                                  element.pokedex == PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.pokedex &&
                                  element.form == PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.form)
                              .first
                              .name,
                          weight: FontWeight.normal,
                          size: 22,
                        ),
                      ),
                    ]
                  : [
                      const Center(
                        child: PlainText(
                          text: '?????????',
                          weight: FontWeight.normal,
                          size: 25,
                        ),
                      ),
                    ],
              ...(state.arg!.uid == UserServices.instance.currentUser!.uid
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Button(
                          onPressed: () async {
                            await ref.read(pokemonEditProvider.notifier).reset();
                            await Future.delayed(Duration.zero, () async {
                              await Navigator.of(context).pushNamed(
                                AppRouting.pokemonEdit,
                                arguments: PokemonEditNotifierArg(
                                  uid: state.arg!.uid,
                                  userName: state.arg!.userName,
                                  index: state.arg!.index,
                                ),
                              );
                            });
                            await ref.read(pokemonDetailProvider.notifier).reset();
                          },
                          buttonHeight: 75,
                          icon: Icons.edit,
                          radius: 75,
                          text: '????????????',
                        ),
                      ),
                    ]
                  : []),
            ],
          ),
        );
        break;
    }
    return screen;
  }
}
