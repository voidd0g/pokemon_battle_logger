import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/widgets/appbar_text.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({
    Key? key,
    required this.onWillPop,
    this.leading,
    this.bottomNavigationBar,
    required this.child,
  }) : super(key: key);

  final Future<bool> Function() onWillPop;
  final Widget? leading;
  final Widget? bottomNavigationBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: ThemeColors.bottomBarBackgroundColor,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: AppbarText(
              text: 'ポケモンバトルログ',
              color: ThemeColors.appbarForegroundColor,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: ThemeColors.appbarBackgroundColor,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ThemeColors.appbarBackgroundColor,
            ),
            leading: leading,
          ),
          backgroundColor: ThemeColors.bodyBackgroundColor,
          body: child,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
