import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/home.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/new.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/popular.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/search.page.notifier.dart';
import 'package:pokemon_battle_logger/notifiers/home/pages/user.page.notifier.dart';
import 'package:pokemon_battle_logger/views/home/pages/home.page.view.dart';
import 'package:pokemon_battle_logger/views/home/pages/new.page.view.dart';
import 'package:pokemon_battle_logger/views/home/pages/popular.page.view.dart';
import 'package:pokemon_battle_logger/views/home/pages/search.page.view.dart';
import 'package:pokemon_battle_logger/views/home/pages/user.page.view.dart';
import 'package:tuple/tuple.dart';

class HomePages {
  static const int newPageIndex = 0;
  static const int popularPageIndex = 1;
  static const int homePageIndex = 2;
  static const int searchPageIndex = 3;
  static const int userPageIndex = 4;

  static List<Tuple2<Widget, StateNotifierProvider<StateNotifier, dynamic>>> getPages() {
    return [
      Tuple2<Widget, StateNotifierProvider>(const NewPageView(), newPageProvider),
      Tuple2<Widget, StateNotifierProvider>(const PopularPageView(), popularPageProvider),
      Tuple2<Widget, StateNotifierProvider>(const HomePageView(), homePageProvider),
      Tuple2<Widget, StateNotifierProvider>(const SearchPageView(), searchPageProvider),
      Tuple2<Widget, StateNotifierProvider>(const UserPageView(), userPageProvider),
    ];
  }
}
