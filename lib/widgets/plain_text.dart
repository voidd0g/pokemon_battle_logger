import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';

class PlainText extends StatelessWidget {
  const PlainText({
    Key? key,
    required this.text,
    required this.weight,
    required this.size,
  }) : super(key: key);

  final String text;
  final FontWeight weight;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'MPLUSRounded1c',
        fontWeight: weight,
        color: ThemeColors.bodyForegroundColor,
        fontSize: size,
      ),
    );
  }
}
