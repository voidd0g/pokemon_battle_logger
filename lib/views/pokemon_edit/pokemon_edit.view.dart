import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/models/pokemon_trained.dart';
import 'package:pokemon_battle_logger/notifier_args/pokemon_edit/pokemon_edit.notifier.arg.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon_choose/pokemon_choose.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/pokemon_edit/pokemon_edit.notifier.dart';
import 'package:pokemon_battle_logger/repos/pokemon.services.dart';
import 'package:pokemon_battle_logger/repos/pokemon_trained.services.dart';
import 'package:pokemon_battle_logger/routing/app_routing.dart';
import 'package:pokemon_battle_logger/states/pokemon_edit/pokemon_edit.state.dart';
import 'package:pokemon_battle_logger/utils/pop_util.dart';
import 'package:pokemon_battle_logger/widgets/app_frame.dart';
import 'package:pokemon_battle_logger/widgets/button.dart';
import 'package:pokemon_battle_logger/widgets/leading_button.dart';
import 'package:pokemon_battle_logger/widgets/plain_text.dart';
import 'package:pokemon_battle_logger/widgets/text_input.dart';

class PokemonEditView extends ConsumerWidget {
  const PokemonEditView({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonEditProvider);
    if (state.stateName == PokemonEditStateName.notInitialized) {
      Future.delayed(Duration.zero, () async {
        await ref.read(pokemonEditProvider.notifier).initialize(arg: ModalRoute.of(context)?.settings.arguments as PokemonEditNotifierArg?);
      });
    }
    if (state.stateName == PokemonEditStateName.redirecting) {
      Future.delayed(Duration.zero, () async {
        await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
      });
    }

    Widget screen;
    switch (state.stateName) {
      case PokemonEditStateName.notInitialized:
      case PokemonEditStateName.initializing:
      case PokemonEditStateName.redirecting:
        screen = AppFrame(
          onWillPop: () async => false,
          title: 'ポケモン',
          child: SpinKitChasingDots(
            color: ThemeColors.spinnerColor,
          ),
        );
        break;
      case PokemonEditStateName.normal:
        screen = AppFrame(
          onWillPop: () async => true,
          title: 'ポケモン',
          leading: LeadingButton(
            onPressed: () async {
              await PopUtil.popOrPushNamed(context: context, name: AppRouting.home);
            },
            icon: Icons.arrow_back,
          ),
          child: ListView(
            children: [
              PlainText(
                text: '${state.arg!.userName}の${state.arg!.index + 1}番目のポケモン',
                weight: FontWeight.normal,
                size: 25,
              ),
              ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: PlainText(
                      text: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index] != null
                          ? PokemonServices.instance.pokemons!
                              .where((element) =>
                                  element.pokedex == PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.pokedex &&
                                  element.form == PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.form)
                              .first
                              .name
                          : '未登録',
                      weight: FontWeight.normal,
                      size: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(
                    onPressed: () async {
                      await ref.read(pokemonChooseProvider.notifier).reset();
                      await Future.delayed(Duration.zero, () async {
                        Map<String, int?>? res = await Navigator.of(context).pushNamed(AppRouting.pokemonChoose) as Map<String, int?>?;
                        if (res?['pokedex'] != null && res?['form'] != null) {
                          PokemonTrainedServices.instance.updatePokemonTrained(
                            data: PokemonTrained(
                              pokedex: res!['pokedex']!,
                              form: res['form']!,
                              nickname: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.nickname ??
                                  PokemonServices.instance.pokemons!.where((element) => element.pokedex == res['pokedex']! && element.form == res['form']!).first.name,
                              abilityId: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.abilityId ?? 0,
                              itemId: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.itemId ?? 0,
                              move1Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move1Id ?? 0,
                              move2Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move2Id ?? 0,
                              move3Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move3Id ?? 0,
                              move4Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move4Id ?? 0,
                              sex: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.sex ?? 0,
                              idValHp: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValHp ?? 0,
                              idValAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValAtk ?? 0,
                              idValDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValDef ?? 0,
                              idValSpAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValSpAtk ?? 0,
                              idValSpDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValSpDef ?? 0,
                              idValSpeed: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValSpeed ?? 0,
                              efValHp: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValHp ?? 0,
                              efValAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValAtk ?? 0,
                              efValDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValDef ?? 0,
                              efValSpAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValSpAtk ?? 0,
                              efValSpDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValSpDef ?? 0,
                              efValSpeed: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValSpeed ?? 0,
                            ),
                            index: state.arg!.index + 1,
                          );
                        }
                      });
                      await ref.read(pokemonEditProvider.notifier).reset();
                    },
                    buttonHeight: 50,
                    radius: 25,
                    icon: Icons.edit,
                    text: 'ポケモンを変更',
                  ),
                )
              ],
              ...PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index] != null
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: PlainText(
                            text: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.nickname,
                            weight: FontWeight.normal,
                            size: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Button(
                          onPressed: () async {
                            final TextEditingController controller = TextEditingController(
                              text: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.nickname,
                            );
                            await showDialog(
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
                                        Navigator.of(context).pop();
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
                                        Navigator.of(context).pop();
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
                            if (controller.text != PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.nickname) {
                              PokemonTrainedServices.instance.updatePokemonTrained(
                                data: PokemonTrained(
                                  pokedex: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.pokedex,
                                  form: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]![state.arg!.index]!.form,
                                  nickname: controller.text,
                                  abilityId: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.abilityId ?? 0,
                                  itemId: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.itemId ?? 0,
                                  move1Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move1Id ?? 0,
                                  move2Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move2Id ?? 0,
                                  move3Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move3Id ?? 0,
                                  move4Id: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.move4Id ?? 0,
                                  sex: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.sex ?? 0,
                                  idValHp: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValHp ?? 0,
                                  idValAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValAtk ?? 0,
                                  idValDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValDef ?? 0,
                                  idValSpAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValSpAtk ?? 0,
                                  idValSpDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValSpDef ?? 0,
                                  idValSpeed: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.idValSpeed ?? 0,
                                  efValHp: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValHp ?? 0,
                                  efValAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValAtk ?? 0,
                                  efValDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValDef ?? 0,
                                  efValSpAtk: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValSpAtk ?? 0,
                                  efValSpDef: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValSpDef ?? 0,
                                  efValSpeed: PokemonTrainedServices.instance.pokemonsTrainedByUsers[state.arg!.uid]?[state.arg!.index]?.efValSpeed ?? 0,
                                ),
                                index: state.arg!.index + 1,
                              );
                              await ref.read(pokemonEditProvider.notifier).reset();
                            }
                          },
                          buttonHeight: 50,
                          radius: 25,
                          icon: Icons.edit,
                          text: 'ニックネームを変更',
                        ),
                      )
                    ]
                  : [],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Button(
                  onPressed: () async {
                    await PokemonTrainedServices.instance.deletePokemonTrained(index: state.arg!.index + 1);
                    await ref.read(pokemonEditProvider.notifier).reset();
                  },
                  buttonHeight: 50,
                  icon: Icons.delete,
                  radius: 25,
                  highlighted: true,
                  text: '削除する',
                ),
              ),
            ],
          ),
        );
        break;
    }
    return screen;
  }
}
