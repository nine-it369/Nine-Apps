import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double button = 14.0;
  static const double squircle = 16.0;
  static const double card = 24.0;
  static const double heroCard = 28.0;
  static const double modal = 32.0;
  static const double sheet = 32.0;
  static const double dialog = 24.0;
  static const double pill = 999.0;

  static BorderRadius smRadius = BorderRadius.circular(sm);
  static BorderRadius mdRadius = BorderRadius.circular(md);
  static BorderRadius buttonRadius = BorderRadius.circular(button);
  static BorderRadius squircleRadius = BorderRadius.circular(squircle);
  static BorderRadius cardRadius = BorderRadius.circular(card);
  static BorderRadius heroRadius = BorderRadius.circular(heroCard);
  static BorderRadius modalRadius = const BorderRadius.vertical(top: Radius.circular(modal));
  static BorderRadius sheetRadius = const BorderRadius.vertical(top: Radius.circular(sheet));
  static BorderRadius dialogRadius = BorderRadius.circular(dialog);
  static BorderRadius pillRadius = BorderRadius.circular(pill);
}
