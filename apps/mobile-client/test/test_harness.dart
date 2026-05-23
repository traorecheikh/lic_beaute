import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTestableWidget(
  Widget child, {
  ThemeData? theme,
  bool scaffold = true,
}) {
  GoogleFonts.config.allowRuntimeFetching = false;

  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) {
      return MaterialApp(
        theme: theme ?? ThemeData(useMaterial3: true),
        home: scaffold ? Scaffold(body: child) : child,
      );
    },
  );
}
