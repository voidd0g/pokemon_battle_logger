import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/models/pokemon.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon_choose/pokemon_choose.notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';
import 'package:pokemon_battle_logger/states/pokemon_choose/pokemon_choose.state.dart';
import 'package:pokemon_battle_logger/utils/pop_util.dart';
import 'package:pokemon_battle_logger/widgets/app_frame.dart';
import 'package:pokemon_battle_logger/widgets/button.dart';
import 'package:pokemon_battle_logger/widgets/leading_button.dart';

class PokemonChooseSearchState {
  final List<Pokemon> showing;
  const PokemonChooseSearchState({
    required this.showing,
  });

  PokemonChooseSearchState copy({
    List<Pokemon>? newShowing,
  }) {
    return PokemonChooseSearchState(
      showing: newShowing ?? showing,
    );
  }
}

final pokemonChooseSearchProvider = StateNotifierProvider<PokemonChooseSearchNotifier, PokemonChooseSearchState>((ref) => PokemonChooseSearchNotifier());

class PokemonChooseSearchNotifier extends StateNotifier<PokemonChooseSearchState> {
  static const PokemonChooseSearchState _defaultState = PokemonChooseSearchState(
    showing: [],
  );

  PokemonChooseSearchNotifier()
      : super(
          _defaultState,
        );

  Future<void> setSearchString(String value) async {
    List<Pokemon> updated = [
      ...PokemonServices.instance.pokemons!.where((element) => element.name.startsWith(value) || element.hiraName.startsWith(value)),
      ...PokemonServices.instance.pokemons!.where((element) => !element.name.startsWith(value) && !element.hiraName.startsWith(value) && (element.name.contains(value) || element.hiraName.contains(value)))
    ];
    if (updated.isNotEmpty) {
      await Future.delayed(Duration.zero, () {
        state = state.copy(
          newShowing: updated,
        );
      });
    }
  }
}

class PokemonChooseView extends ConsumerWidget {
  const PokemonChooseView({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonChooseProvider);
    if (state.stateName == PokemonChooseStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(pokemonChooseProvider.notifier).initialize();
        await ref.read(pokemonChooseSearchProvider.notifier).setSearchString('');
      });
    }
    if (state.stateName == PokemonChooseStateName.redirecting) {
      Future.delayed(Duration.zero, () async {
        await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
      });
    }

    Widget screen;
    switch (state.stateName) {
      case PokemonChooseStateName.notInitialized:
      case PokemonChooseStateName.initializing:
      case PokemonChooseStateName.redirecting:
        screen = AppFrame(
          onWillPop: () async => false,
          title: 'ポケモン',
          child: SpinKitChasingDots(
            color: ThemeColors.spinnerColor,
          ),
        );
        break;
      case PokemonChooseStateName.normal:
        screen = AppFrame(
          onWillPop: () async {
            Navigator.of(context).pop({
              'pokedex': null,
              'form': null,
            });
            return false;
          },
          title: 'ポケモンを変更',
          leading: LeadingButton(
            onPressed: () async {
              Navigator.of(context).pop({
                'pokedex': null,
                'form': null,
              });
            },
            icon: Icons.arrow_back,
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(pokemonChooseSearchProvider);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.search,
                        ),
                      ),
                      onChanged: (value) async {
                        await ref.read(pokemonChooseSearchProvider.notifier).setSearchString(value);
                      },
                    ),
                  ),
                  ...state.showing
                      .map(
                        (value) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Button(
                              onPressed: () async {
                                Navigator.of(context).pop({
                                  'pokedex': value.pokedex,
                                  'form': value.form,
                                });
                              },
                              buttonHeight: 30,
                              radius: 15,
                              highlighted: true,
                              icon: Icons.check_circle_outline_outlined,
                              text: value.name),
                        ),
                      )
                      .toList()
                ],
              );
            },
          ),
        );
        break;
    }
    return screen;
  }
}
