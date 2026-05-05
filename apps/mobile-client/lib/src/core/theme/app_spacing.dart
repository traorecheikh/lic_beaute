import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double full = 9999;
}

extension AppSpacingExtension on double {
  SizedBox get gapH => SizedBox(height: this);
  SizedBox get gapW => SizedBox(width: this);
}

const gapH4 = SizedBox(height: 4);
const gapH8 = SizedBox(height: 8);
const gapH12 = SizedBox(height: 12);
const gapH16 = SizedBox(height: 16);
const gapH24 = SizedBox(height: 24);
const gapH32 = SizedBox(height: 32);
const gapH48 = SizedBox(height: 48);

const gapW4 = SizedBox(width: 4);
const gapW8 = SizedBox(width: 8);
const gapW12 = SizedBox(width: 12);
const gapW16 = SizedBox(width: 16);
const gapW24 = SizedBox(width: 24);
const gapW32 = SizedBox(width: 32);
const gapW48 = SizedBox(width: 48);
