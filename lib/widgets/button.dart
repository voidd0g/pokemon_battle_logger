import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';
import 'package:pokemon_battle_logger/widgets/button_text.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.onPressed,
    required this.buttonHeight,
    this.prefix,
    this.suffix,
    this.radius = 0,
    required this.icon,
    required this.text,
    this.highlighted = false,
  }) : super(key: key);

  final void Function()? onPressed;
  final double buttonHeight;
  final Widget? prefix;
  final Widget? suffix;
  final double radius;
  final IconData icon;
  final String text;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return highlighted ? ThemeColors.buttonHighlightedBackgroundColor : ThemeColors.buttonBackgroundColor;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return highlighted ? ThemeColors.buttonHighlightedForegroundColor : ThemeColors.buttonForegroundColor;
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          return highlighted ? ThemeColors.buttonHighlightedOverlayColor : ThemeColors.buttonOverlayColor;
        }),
        shape: MaterialStateProperty.resolveWith((states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          );
        }),
      ),
      child: SizedBox(
        height: buttonHeight,
        child: Stack(
          children: [
            if (prefix != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: prefix!,
                  ),
                ],
              ),
            Center(
              child: ButtonText(
                icon: icon,
                text: text,
                color: highlighted ? ThemeColors.buttonHighlightedForegroundColor : ThemeColors.buttonForegroundColor,
                size: 18.0,
              ),
            ),
            if (suffix != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: suffix!,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
