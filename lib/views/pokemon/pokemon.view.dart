import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon/pokemon.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon_detail/pokemon_detail.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon/pokemon.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon_detail/pokemon_detail.notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/repos/pokemon_trained.services.dart';
import 'package:pokemon_battle_logger/repos/user.services.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';
import 'package:pokemon_battle_logger/states/pokemon/pokemon.state.dart';
import 'package:pokemon_battle_logger/utils/pop_util.dart';
import 'package:pokemon_battle_logger/widgets/app_frame.dart';
import 'package:pokemon_battle_logger/widgets/leading_button.dart';
import 'package:pokemon_battle_logger/widgets/plain_text.dart';

class PokemonView extends ConsumerWidget {
  const PokemonView({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);
    if (state.stateName == PokemonStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(pokemonProvider.notifier).initialize(arg: ModalRoute.of(context)?.settings.arguments as PokemonNotifierArg?);
      });
    }
    if (state.stateName == PokemonStateName.redirecting) {
      Future.delayed(Duration.zero, () async {
        await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
      });
    }

    Widget screen;
    switch (state.stateName) {
      case PokemonStateName.notInitialized:
      case PokemonStateName.initializing:
      case PokemonStateName.redirecting:
        screen = AppFrame(
          onWillPop: () async => false,
          title: 'ポケモンいちらん',
          child: SpinKitChasingDots(
            color: ThemeColors.spinnerColor,
          ),
        );
        break;
      case PokemonStateName.normal:
        screen = AppFrame(
          onWillPop: () async => true,
          title: 'ポケモンいちらん',
          leading: LeadingButton(
            onPressed: () async {
              await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
            },
            icon: Icons.arrow_back,
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: PlainText(text: '${state.arg?.userName ?? UserServices.instance.currentUser!.displayName}のポケモン', weight: FontWeight.bold, size: 22),
                ),
              ),
              ...PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg?.uid ?? UserServices.instance.currentUser!.uid]!.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: GestureDetector(
                          onTap: () async {
                            await ref.read(pokemonDetailProvider.notifier).reset();
                            await Future.delayed(Duration.zero, () async {
                              await Navigator.of(context).pushNamed(
                                AppRouting.pokemonDetail,
                                arguments: PokemonDetailNotifierArg(
                                  uid: state.arg?.uid ?? UserServices.instance.currentUser!.uid,
                                  userName: state.arg?.userName ?? UserServices.instance.currentUser!.displayName,
                                  index: entry.key,
                                ),
                              );
                            });
                            await ref.read(pokemonProvider.notifier).reset();
                          },
                          child: Container(
                            color: ThemeColors.buttonHighlightedBackgroundColor,
                            height: 200,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: PlainText(
                                          text: (entry.key + 1).toString(),
                                          weight: FontWeight.normal,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: entry.value != null
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            PlainText(
                                              text: entry.value!.nickname,
                                              weight: FontWeight.normal,
                                              size: 25,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            PlainText(
                                              text: PokemonServices.instance.pokemons!.where((element) => element.pokedex == entry.value!.pokedex && element.form == entry.value!.form).first.name,
                                              weight: FontWeight.normal,
                                              size: 22,
                                            )
                                          ],
                                        )
                                      : const PlainText(
                                          text: '未登録',
                                          weight: FontWeight.normal,
                                          size: 25,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
    }

    return screen;
  }
}
