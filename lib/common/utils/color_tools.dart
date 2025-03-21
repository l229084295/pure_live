// lib/utils/color_tools.dart
import 'package:flutter/material.dart';

class ColorTools {
  static ColorSwatch<Object> createPrimarySwatch(Color color) {
    return MaterialColor(color.value, {
      50: Color.alphaBlend(color.withOpacity(0.1), Colors.white),
      100: Color.alphaBlend(color.withOpacity(0.2), Colors.white),
      200: Color.alphaBlend(color.withOpacity(0.3), Colors.white),
      300: Color.alphaBlend(color.withOpacity(0.4), Colors.white),
      400: Color.alphaBlend(color.withOpacity(0.6), Colors.white),
      500: color,
      600: Color.alphaBlend(color.withOpacity(0.8), Colors.black),
      700: Color.alphaBlend(color.withOpacity(0.85), Colors.black),
      800: Color.alphaBlend(color.withOpacity(0.9), Colors.black),
      900: Color.alphaBlend(color.withOpacity(0.95), Colors.black),
    });
  }
}

extension ColorExtension on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}