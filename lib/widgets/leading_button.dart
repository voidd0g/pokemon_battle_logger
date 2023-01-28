import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';

class LeadingButton extends StatelessWidget {
  const LeadingButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final void Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return ThemeColors.appbarBackgroundColor;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return ThemeColors.appbarForegroundColor;
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          return ThemeColors.buttonOverlayColor;
        }),
        shape: MaterialStateProperty.resolveWith((states) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          );
        }),
      ),
      child: Center(
        child: Icon(icon),
      ),
    );
  }
}
