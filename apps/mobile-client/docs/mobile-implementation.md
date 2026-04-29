 Plan — Flutter Mobile Client (BeauteAvenue)
                                                                                      
 Context                                                

 API is complete (57+ routes, 19/19 tests green). This plan builds the Flutter client
  app from near-scratch.
 Current state: apps/mobile-client has only a skeleton — 3 placeholder screens, no
 providers, no theme tokens,
 no generated API code, no routing guards. The goal is a production-ready Flutter
 client with:
 - Zero hardcoded API calls (generated from OpenAPI spec)
 - Zero hardcoded design values (all tokens in theme files)
 - Zero hardcoded strings (all in AppStrings)
 - Zero hardcoded storage keys (all in StorageKeys)
 - Responsive via flutter_screenutil (.r .sp .w .h)
 - Riverpod codegen providers + GoRouter with guards
 - Established packages for every non-trivial concern

 Consumer surfaces: Flutter client = apps/mobile-client. API = http://localhost:3000.
 Design source: docs/DESIGN.md. Screen spec: docs/implementation/30-mobile-client.md.
 OpenAPI spec: apps/api/openapi/openapi.json (must be regenerated first).

 Priority order:
 1. pubspec.yaml — add all packages
 2. OpenAPI regeneration → Flutter code generation
 3. Theme system — complete, no hardcoding
 4. Core infra (env, Dio, storage, session, constants)
 5. Router — all 21+ routes + guards
 6. Providers — all Riverpod providers
 7. Views — last (shells + placeholders, then real UI)

 ---
 Critical Files

 ┌────────────────────────────────────────────────────────────┬──────────────────┐
 │                            File                            │      Action      │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/pubspec.yaml                            │ Add ~20 new      │
 │                                                            │ packages         │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/theme/app_colors.dart      │ CREATE — all 42  │
 │                                                            │ color tokens     │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/theme/app_text_styles.dart │ CREATE — 9 type  │
 │                                                            │ tokens           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │                                                            │ CREATE — spacing │
 │ apps/mobile-client/lib/src/core/theme/app_spacing.dart     │  + radius +      │
 │                                                            │ shadows          │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │                                                            │ REWRITE — full   │
 │ apps/mobile-client/lib/src/core/theme/app_theme.dart       │ ThemeData using  │
 │                                                            │ tokens           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/constants/storage_keys.dar │ CREATE           │
 │ t                                                          │                  │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/constants/app_strings.dart │ CREATE           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │                                                            │ CREATE —         │
 │ apps/mobile-client/lib/src/core/env/app_env.dart           │ envied-based     │
 │                                                            │ config           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/network/dio_client.dart    │ CREATE — Dio +   │
 │                                                            │ interceptors     │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/storage/secure_storage.dar │ CREATE — typed   │
 │ t                                                          │ wrapper          │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/storage/app_cache.dart     │ CREATE — hive_ce │
 │                                                            │  wrapper         │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/core/session/session_store.dart │ REWRITE — use    │
 │                                                            │ secure_storage   │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │                                                            │ CREATE — openapi │
 │ apps/mobile-client/lib/src/generated/                      │ -generator       │
 │                                                            │ output           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/router/app_router.dart          │ REWRITE — full   │
 │                                                            │ GoRouter         │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/features/auth/providers/        │ CREATE           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/features/discovery/providers/   │ CREATE           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/features/booking/providers/     │ CREATE           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/features/profile/providers/     │ CREATE           │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/features/notifications/provider │ CREATE           │
 │ s/                                                         │                  │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │                                                            │ UPDATE —         │
 │ apps/mobile-client/lib/main.dart                           │ ScreenUtilInit + │
 │                                                            │  ProviderScope + │
 │                                                            │  Hive init       │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/lib/src/app.dart                        │ UPDATE — router  │
 │                                                            │ + theme wiring   │
 ├────────────────────────────────────────────────────────────┼──────────────────┤
 │ apps/mobile-client/.env                                    │ CREATE from      │
 │                                                            │ .env.example     │
 └────────────────────────────────────────────────────────────┴──────────────────┘

 ---
 Step 1 — pubspec.yaml: Add All Packages

 Run from apps/mobile-client/:

 flutter pub add flutter_screenutil riverpod_annotation go_router dio \
   flutter_secure_storage hive_ce hive_ce_flutter cached_network_image \
   connectivity_plus url_launcher pinput intl shimmer \
   firebase_core firebase_messaging flutter_local_notifications \
   envied json_annotation freezed_annotation

 flutter pub add --dev build_runner json_serializable freezed \
   riverpod_generator riverpod_lint custom_lint hive_ce_generator \
   envied_generator

 Final pubspec.yaml dependencies (full list):

 dependencies:
   flutter:
     sdk: flutter
   # State
   flutter_riverpod: ^2.6.1
   riverpod_annotation: ^2.6.1
   # Navigation
   go_router: ^14.6.2
   # HTTP
   dio: ^5.7.0
   # Responsive
   flutter_screenutil: ^5.9.3
   # Storage
   flutter_secure_storage: ^9.2.2
   hive_ce: ^2.9.0
   hive_ce_flutter: ^2.2.0
   # Network images
   cached_network_image: ^3.4.1
   # Connectivity
   connectivity_plus: ^6.1.0
   # External URLs (payment handoff)
   url_launcher: ^6.3.0
   # OTP input widget
   pinput: ^3.0.1
   # Internationalisation + currency formatting
   intl: ^0.19.0
   # Skeleton loading
   shimmer: ^3.0.0
   # Push notifications
   firebase_core: ^3.6.0
   firebase_messaging: ^15.1.3
   flutter_local_notifications: ^18.0.1
   # Env config (no hardcoded URLs)
   envied: ^0.5.4
   # Model serialization
   json_annotation: ^4.9.0
   freezed_annotation: ^2.4.4

 dev_dependencies:
   flutter_test:
     sdk: flutter
   flutter_lints: ^5.0.0
   build_runner: ^2.4.13
   json_serializable: ^6.8.0
   freezed: ^2.5.7
   riverpod_generator: ^2.6.3
   riverpod_lint: ^2.6.3
   custom_lint: ^0.6.7
   hive_ce_generator: ^1.8.0
   envied_generator: ^0.5.4

 flutter:
   uses-material-design: true
   fonts:
     - family: CormorantGaramond
       fonts:
         - asset: assets/fonts/CormorantGaramond-Regular.ttf
           weight: 400
         - asset: assets/fonts/CormorantGaramond-SemiBold.ttf
           weight: 600
     - family: Inter
       fonts:
         - asset: assets/fonts/Inter-Regular.ttf
           weight: 400
         - asset: assets/fonts/Inter-Medium.ttf
           weight: 500
         - asset: assets/fonts/Inter-SemiBold.ttf
           weight: 600
         - asset: assets/fonts/Inter-Bold.ttf
           weight: 700

 Add analysis_options.yaml linter:
 include: package:flutter_lints/flutter.yaml
 analyzer:
   plugins:
     - custom_lint

 ---
 Step 2 — OpenAPI Regeneration + Flutter Code Generation

 2a. Regenerate openapi.json (from repo root)

 pnpm openapi:generate
 This regenerates apps/api/openapi/openapi.json from the full contracts package (57+
 routes).

 2b. Generate Flutter Dio client

 Install generator (once, if not present):
 npm install @openapitools/openapi-generator-cli -g

 Run from apps/mobile-client/:
 openapi-generator-cli generate \
   -i ../../apps/api/openapi/openapi.json \
   -g dart-dio \
   -o lib/src/generated \
   --additional-properties=pubName=beauteavenue_api,nullSafe=true,pubVersion=0.1.0

 This creates:
 - lib/src/generated/lib/api/ — typed API classes (AuthApi, SalonsApi, BookingsApi,
 etc.)
 - lib/src/generated/lib/model/ — Dart model classes (AuthSession, SalonSummary,
 etc.)

 ▎ After generation: flutter pub run build_runner build --delete-conflicting-outputs

 The generated package is referenced locally; its models are the single source of
 truth for
 types throughout the app — never manually write request/response Dart classes.

 ---
 Step 3 — Theme System (Complete, No Hardcoding)

 3a. lib/src/core/theme/app_colors.dart

 import 'package:flutter/material.dart';

 abstract final class AppColors {
   // ── Brand accents ────────────────────────────────────────────────────────
   static const primary           = Color(0xFFD96B8C); // Rose Pétale
   static const onPrimary         = Color(0xFFFFFFFF);
   static const primaryContainer  = Color(0xFFFFD9E6);
   static const onPrimaryContainer = Color(0xFF3B0021);

   static const secondary         = Color(0xFFC9A26A); // Or Champagne
   static const onSecondary       = Color(0xFF2D1A12);
   static const secondaryContainer = Color(0xFFFCEFD8);
   static const onSecondaryContainer = Color(0xFF291900);

   static const tertiary          = Color(0xFF8B4A2E); // Argile Foncée
   static const onTertiary        = Color(0xFFFFFFFF);
   static const tertiaryContainer = Color(0xFFFFDBC8);
   static const onTertiaryContainer = Color(0xFF3A0E00);

   // ── Neutral surfaces ─────────────────────────────────────────────────────
   static const neutral           = Color(0xFFF6F6F6); // Page background (60%)
   static const surface           = Color(0xFFFFFFFF); // Cards, modals (30%)
   static const surfaceVariant    = Color(0xFFF0F0F0); // Inputs, secondary surfaces
   static const onSurface         = Color(0xFF1A1A1A); // Primary text
   static const onSurfaceVariant  = Color(0xFF5C5C5C); // Secondary text
   static const outline           = Color(0xFFC2C2C2);
   static const outlineVariant    = Color(0xFFE0E0E0);

   // ── Dark mode ────────────────────────────────────────────────────────────
   static const darkBackground    = Color(0xFF121212);
   static const darkSurface       = Color(0xFF1E1E1E);
   static const darkSurfaceVariant = Color(0xFF2C2C2C);
   static const darkOnSurface     = Color(0xFFF0F0F0);
   static const darkOnSurfaceVariant = Color(0xFFA0A0A0);
   static const darkOutline       = Color(0xFF3A3A3A);

   // ── Semantic ─────────────────────────────────────────────────────────────
   static const error             = Color(0xFFBA1A1A);
   static const onError           = Color(0xFFFFFFFF);
   static const errorContainer    = Color(0xFFFFDAD6);
   static const onErrorContainer  = Color(0xFF410002);

   // ── Status ───────────────────────────────────────────────────────────────
   static const statusPendingBg   = Color(0xFFFFF3CD);
   static const statusPendingText = Color(0xFF92600A);
   static const statusPendingBorder = Color(0xFFF0C060);

   static const statusConfirmedBg  = Color(0xFFDBEAFE);
   static const statusConfirmedText = Color(0xFF1E40AF);
   static const statusConfirmedBorder = Color(0xFF93C5FD);

   static const statusCheckedInBg  = Color(0xFFD1FAE5);
   static const statusCheckedInText = Color(0xFF065F46);
   static const statusCheckedInBorder = Color(0xFF6EE7B7);

   // ── Staff calendar tones (8) ─────────────────────────────────────────────
   static const staffTone1 = Color(0xFFFCE4EC);
   static const staffTone2 = Color(0xFFE3F2FD);
   static const staffTone3 = Color(0xFFE8F5E9);
   static const staffTone4 = Color(0xFFFFF8E1);
   static const staffTone5 = Color(0xFFF3E5F5);
   static const staffTone6 = Color(0xFFE0F7FA);
   static const staffTone7 = Color(0xFFFBE9E7);
   static const staffTone8 = Color(0xFFEDE7F6);
 }

 3b. lib/src/core/theme/app_spacing.dart

 abstract final class AppSpacing {
   static const double xs  = 4;
   static const double sm  = 8;
   static const double md  = 16;
   static const double lg  = 24;
   static const double xl  = 32;
   static const double xxl = 48;
   static const double xxxl = 64;
 }

 abstract final class AppRadius {
   static const double xs   = 4;
   static const double sm   = 8;
   static const double md   = 12;
   static const double lg   = 16;
   static const double xl   = 24;
   static const double xxl  = 32;
   static const double full = 9999;
 }

 3c. lib/src/core/theme/app_shadows.dart

 import 'package:flutter/material.dart';

 abstract final class AppShadows {
   static const sm = [BoxShadow(color: Color(0x14000000), blurRadius: 3,  offset:
 Offset(0, 1))];
   static const md = [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset:
 Offset(0, 4))];
   static const lg = [BoxShadow(color: Color(0x24000000), blurRadius: 48, offset:
 Offset(0, 16))];
   static const panel = [BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset:
 Offset(0, 4))];
 }

 3d. lib/src/core/theme/app_text_styles.dart

 Uses ScreenUtil .sp for responsive font scaling. Import in theme build.

 import 'package:flutter/material.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'app_colors.dart';

 abstract final class AppTextStyles {
   // Display — Cormorant Garamond (serif, hero moments only)
   static TextStyle get displayLg => TextStyle(fontFamily: 'CormorantGaramond',
 fontSize: 56.sp, fontWeight: FontWeight.w600, color: AppColors.onSurface, height:
 1.1);
   static TextStyle get displayMd => TextStyle(fontFamily: 'CormorantGaramond',
 fontSize: 40.sp, fontWeight: FontWeight.w600, color: AppColors.onSurface, height:
 1.2);

   // Headline — Cormorant Garamond (salon names, page titles)
   static TextStyle get headlineLg => TextStyle(fontFamily: 'CormorantGaramond',
 fontSize: 32.sp, fontWeight: FontWeight.w600, color: AppColors.onSurface, height:
 1.25);
   // Inter for functional headlines
   static TextStyle get headlineMd => TextStyle(fontFamily: 'Inter', fontSize: 20.sp,
  fontWeight: FontWeight.w600, color: AppColors.onSurface, height: 1.3);

   // Body — Inter
   static TextStyle get bodyLg => TextStyle(fontFamily: 'Inter', fontSize: 18.sp,
 fontWeight: FontWeight.w400, color: AppColors.onSurface, height: 1.5);
   static TextStyle get bodyMd => TextStyle(fontFamily: 'Inter', fontSize: 16.sp,
 fontWeight: FontWeight.w400, color: AppColors.onSurface, height: 1.5);
   static TextStyle get bodySm => TextStyle(fontFamily: 'Inter', fontSize: 14.sp,
 fontWeight: FontWeight.w400, color: AppColors.onSurfaceVariant, height: 1.45);

   // Label — Inter (buttons, badges, nav)
   static TextStyle get labelLg => TextStyle(fontFamily: 'Inter', fontSize: 14.sp,
 fontWeight: FontWeight.w600, color: AppColors.onSurface, height: 1.2, letterSpacing:
  0.1);
   static TextStyle get labelSm => TextStyle(fontFamily: 'Inter', fontSize: 12.sp,
 fontWeight: FontWeight.w600, color: AppColors.onSurface, height: 1.2, letterSpacing:
  0.4);
 }

 3e. lib/src/core/theme/app_theme.dart (full ThemeData)

 import 'package:flutter/material.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'app_colors.dart';
 import 'app_spacing.dart';
 import 'app_text_styles.dart';

 abstract final class AppTheme {
   static ThemeData get light => ThemeData(
     useMaterial3: true,
     colorScheme: const ColorScheme.light(
       primary: AppColors.primary,
       onPrimary: AppColors.onPrimary,
       primaryContainer: AppColors.primaryContainer,
       onPrimaryContainer: AppColors.onPrimaryContainer,
       secondary: AppColors.secondary,
       onSecondary: AppColors.onSecondary,
       secondaryContainer: AppColors.secondaryContainer,
       onSecondaryContainer: AppColors.onSecondaryContainer,
       tertiary: AppColors.tertiary,
       onTertiary: AppColors.onTertiary,
       tertiaryContainer: AppColors.tertiaryContainer,
       onTertiaryContainer: AppColors.onTertiaryContainer,
       error: AppColors.error,
       onError: AppColors.onError,
       errorContainer: AppColors.errorContainer,
       onErrorContainer: AppColors.onErrorContainer,
       surface: AppColors.surface,
       onSurface: AppColors.onSurface,
       surfaceContainerHighest: AppColors.surfaceVariant,
       onSurfaceVariant: AppColors.onSurfaceVariant,
       outline: AppColors.outline,
       outlineVariant: AppColors.outlineVariant,
     ),
     scaffoldBackgroundColor: AppColors.neutral,
     fontFamily: 'Inter',
     textTheme: TextTheme(
       displayLarge: AppTextStyles.displayLg,
       displayMedium: AppTextStyles.displayMd,
       headlineLarge: AppTextStyles.headlineLg,
       headlineMedium: AppTextStyles.headlineMd,
       bodyLarge: AppTextStyles.bodyLg,
       bodyMedium: AppTextStyles.bodyMd,
       bodySmall: AppTextStyles.bodySm,
       labelLarge: AppTextStyles.labelLg,
       labelSmall: AppTextStyles.labelSm,
     ),
     cardTheme: CardTheme(
       color: AppColors.surface,
       elevation: 0,
       shape: RoundedRectangleBorder(borderRadius:
 BorderRadius.circular(AppRadius.xl.r)),
     ),
     elevatedButtonTheme: ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
         backgroundColor: AppColors.primary,
         foregroundColor: AppColors.onPrimary,
         textStyle: AppTextStyles.labelLg,
         padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
         shape: StadiumBorder(),
         elevation: 0,
         minimumSize: Size(double.infinity, 52.h),
       ),
     ),
     outlinedButtonTheme: OutlinedButtonThemeData(
       style: OutlinedButton.styleFrom(
         foregroundColor: AppColors.onSurfaceVariant,
         textStyle: AppTextStyles.labelLg,
         padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 13.h),
         shape: StadiumBorder(),
         side: BorderSide(color: AppColors.outline),
         minimumSize: Size(double.infinity, 52.h),
       ),
     ),
     inputDecorationTheme: InputDecorationTheme(
       filled: true,
       fillColor: AppColors.surfaceVariant,
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(AppRadius.md.r),
         borderSide: BorderSide.none,
       ),
       enabledBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(AppRadius.md.r),
         borderSide: BorderSide.none,
       ),
       focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(AppRadius.md.r),
         borderSide: BorderSide(color: AppColors.primary, width: 1.5),
       ),
       errorBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(AppRadius.md.r),
         borderSide: BorderSide(color: AppColors.error),
       ),
       contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
       hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
     ),
     appBarTheme: AppBarTheme(
       backgroundColor: AppColors.neutral,
       elevation: 0,
       scrolledUnderElevation: 0,
       centerTitle: false,
       titleTextStyle: AppTextStyles.headlineMd,
       iconTheme: IconThemeData(color: AppColors.onSurface),
     ),
     bottomNavigationBarTheme: BottomNavigationBarThemeData(
       backgroundColor: AppColors.surface,
       selectedItemColor: AppColors.primary,
       unselectedItemColor: AppColors.onSurfaceVariant,
       selectedLabelStyle: AppTextStyles.labelSm,
       unselectedLabelStyle: AppTextStyles.labelSm,
       type: BottomNavigationBarType.fixed,
       elevation: 8,
     ),
     dividerTheme: const DividerThemeData(color: AppColors.outlineVariant, thickness:
  1, space: 1),
     chipTheme: ChipThemeData(
       backgroundColor: AppColors.surfaceVariant,
       labelStyle: AppTextStyles.labelSm,
       shape: StadiumBorder(),
       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
     ),
     snackBarTheme: SnackBarThemeData(
       backgroundColor: AppColors.onSurface,
       contentTextStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.surface),
       behavior: SnackBarBehavior.floating,
       shape: RoundedRectangleBorder(borderRadius:
 BorderRadius.circular(AppRadius.md.r)),
     ),
   );

   static ThemeData get dark => light.copyWith(
     colorScheme: const ColorScheme.dark(
       primary: AppColors.primary,
       onPrimary: AppColors.onPrimary,
       surface: AppColors.darkSurface,
       onSurface: AppColors.darkOnSurface,
       surfaceContainerHighest: AppColors.darkSurfaceVariant,
       onSurfaceVariant: AppColors.darkOnSurfaceVariant,
       outline: AppColors.darkOutline,
     ),
     scaffoldBackgroundColor: AppColors.darkBackground,
     cardTheme: CardTheme(
       color: AppColors.darkSurface,
       elevation: 0,
       shape: RoundedRectangleBorder(borderRadius:
 BorderRadius.circular(AppRadius.xl.r)),
     ),
   );
 }

 ---
 Step 4 — Constants (Zero Hardcoding)

 lib/src/core/constants/storage_keys.dart

 abstract final class StorageKeys {
   // Secure storage (flutter_secure_storage)
   static const accessToken   = 'ba_access_token';
   static const refreshToken  = 'ba_refresh_token';
   static const userId        = 'ba_user_id';
   static const userRole      = 'ba_user_role';

   // Hive box names
   static const salonCacheBox     = 'ba_salons';
   static const bookingCacheBox   = 'ba_bookings';
   static const notificationBox   = 'ba_notifications';
   static const profileBox        = 'ba_profile';
   static const settingsBox       = 'ba_settings';

   // Hive keys (within boxes)
   static const salonListKey   = 'salon_list';
   static const salonListEtag  = 'salon_list_etag';
   static const currentUser    = 'current_user';
 }

 lib/src/core/constants/app_strings.dart

 Complete French string constants — every UI-visible string lives here. Example
 structure:

 abstract final class AppStrings {
   // Auth
   static const authTitle          = 'Bienvenue';
   static const authSubtitle       = 'Découvrez des salons près de vous';
   static const continueWithEmail  = 'Continuer avec email';
   static const continueWithPhone  = 'Continuer avec téléphone';
   static const loginTitle         = 'Se connecter';
   static const loginCta           = 'Se connecter';
   static const emailLabel         = 'Adresse email';
   static const passwordLabel      = 'Mot de passe';
   static const phoneLabel         = 'Numéro de téléphone';
   static const otpTitle           = 'Code de vérification';
   static const otpSubtitle        = 'Entrez le code envoyé au ';
   static const otpCta             = 'Vérifier';
   static const otpResend          = 'Renvoyer le code';
   static const otpResendIn        = 'Renvoyer dans ';
   static const profileBootstrapTitle = 'Mon profil';
   static const profileBootstrapCta   = 'Enregistrer mon profil';
   static const fullNameLabel      = 'Nom complet';

   // Discovery
   static const discoverTab        = 'Découvrir';
   static const bookingsTab        = 'Mes RDV';
   static const profileTab         = 'Profil';
   static const searchHint         = 'Salon, prestation, ville...';
   static const filtersTitle       = 'Filtres';
   static const filtersCta         = 'Appliquer les filtres';
   static const salonDetailCta     = 'Choisir une prestation';
   static const favoritesTitle     = 'Mes favoris';
   static const favoritesEmpty     = 'Aucun salon favori pour l\'instant.';

   // Booking funnel
   static const bookingStep1       = 'Étape 1/4 — Prestation';
   static const bookingStep2       = 'Étape 2/4 — Créneau';
   static const bookingStep3       = 'Étape 3/4 — Confirmation';
   static const bookingStep4       = 'Étape 4/4 — Paiement';
   static const selectServiceTitle = 'Choisir une prestation';
   static const selectStaffTitle   = 'Choisir un prestataire';
   static const noPreference       = 'Pas de préférence';
   static const selectSlotTitle    = 'Choisir un créneau';
   static const bookingReviewTitle = 'Confirmation';
   static const confirmBookingCta  = 'Confirmer la réservation';
   static const payDepositCta      = 'Payer l\'acompte';
   static const bookingSuccessTitle = 'Réservation confirmée !';
   static const viewBookingCta     = 'Voir mon rendez-vous';
   static const slotUnavailable    = 'Ce créneau n\'est plus disponible.';

   // Booking management
   static const bookingsTitle      = 'Mes rendez-vous';
   static const bookingsEmpty      = 'Aucun rendez-vous pour l\'instant.';
   static const cancelBookingCta   = 'Annuler la réservation';
   static const rescheduleBookingCta = 'Modifier le créneau';
   static const confirmCancelCta   = 'Confirmer l\'annulation';

   // Reviews
   static const reviewTitle        = 'Votre avis';
   static const reviewCta          = 'Publier mon avis';
   static const reviewCommentLabel = 'Commentaire (optionnel)';

   // Profile
   static const profileTitle       = 'Mon profil';
   static const profileSaveCta     = 'Enregistrer';
   static const logoutCta          = 'Se déconnecter';
   static const notificationsTitle = 'Notifications';
   static const markAllReadCta     = 'Tout marquer comme lu';
   static const notificationsEmpty = 'Aucune notification.';

   // General
   static const retry              = 'Réessayer';
   static const loading            = 'Chargement...';
   static const errorGeneric       = 'Une erreur est survenue.';
   static const offlineBanner      = 'Vous êtes hors ligne. Certaines données peuvent
  être obsolètes.';
   static const closeDialog        = 'Fermer';
   static const cancel             = 'Annuler';
   static const confirm            = 'Confirmer';
 }

 ---
 Step 5 — Environment Config (envied)

 apps/mobile-client/.env

 API_BASE_URL=http://10.0.2.2:3000

 lib/src/core/env/app_env.dart

 import 'package:envied/envied.dart';

 part 'app_env.g.dart';

 @Envied(path: '.env', obfuscate: false)
 abstract final class AppEnv {
   @EnviedField(varName: 'API_BASE_URL', defaultValue: 'http://10.0.2.2:3000')
   static const String apiBaseUrl = _AppEnv.apiBaseUrl;
 }

 After creating: flutter pub run build_runner build

 ---
 Step 6 — Core Network (Dio + Interceptors)

 lib/src/core/network/dio_client.dart

 // Dio singleton factory with:
 // - BaseOptions: baseUrl from AppEnv.apiBaseUrl, connectTimeout 15s, receiveTimeout
  30s
 // - AuthInterceptor: reads accessToken from SecureStorage, injects Bearer header
 // - RefreshInterceptor: on 401, calls POST /auth/refresh, rotates tokens, retries
 original request
 // - ConnectivityInterceptor: throws OfflineException if no connectivity
 // - LoggingInterceptor: debug-only, prints requests/responses

 class DioClient {
   static Dio create({required SecureStorage secureStorage}) {
     final dio = Dio(BaseOptions(
       baseUrl: AppEnv.apiBaseUrl,
       connectTimeout: Duration(seconds: 15),
       receiveTimeout: Duration(seconds: 30),
       headers: {'Content-Type': 'application/json'},
     ));
     dio.interceptors.addAll([
       AuthInterceptor(secureStorage: secureStorage),
       RefreshInterceptor(secureStorage: secureStorage),
       if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
     ]);
     return dio;
   }
 }

 AuthInterceptor: reads StorageKeys.accessToken from SecureStorage, injects
 Authorization: Bearer $token on every request.

 RefreshInterceptor: on 401, reads StorageKeys.refreshToken, calls POST
 /api/v1/auth/refresh, saves new tokens via SecureStorage, retries queued requests.
 On refresh failure → clears all tokens → emits logout event via a StreamController
 in session store.

 ---
 Step 7 — Storage Layers

 lib/src/core/storage/secure_storage.dart

 // Typed wrapper over FlutterSecureStorage.
 // All keys come from StorageKeys — never raw strings here.
 class SecureStorage {
   final _storage = const FlutterSecureStorage(
     aOptions: AndroidOptions(encryptedSharedPreferences: true),
     iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
   );

   Future<String?> read(String key) => _storage.read(key: key);
   Future<void> write(String key, String value) => _storage.write(key: key, value:
 value);
   Future<void> delete(String key) => _storage.delete(key: key);
   Future<void> deleteAll() => _storage.deleteAll();
 }

 lib/src/core/storage/app_cache.dart

 // Typed hive_ce wrapper.
 // All box names come from StorageKeys — never raw strings here.
 class AppCache {
   static Future<void> init() async {
     await Hive.initFlutter();
     // Open boxes
     await Hive.openBox(StorageKeys.salonCacheBox);
     await Hive.openBox(StorageKeys.bookingCacheBox);
     await Hive.openBox(StorageKeys.notificationBox);
     await Hive.openBox(StorageKeys.profileBox);
     await Hive.openBox(StorageKeys.settingsBox);
   }

   Box get salons => Hive.box(StorageKeys.salonCacheBox);
   Box get bookings => Hive.box(StorageKeys.bookingCacheBox);
   Box get notifications => Hive.box(StorageKeys.notificationBox);
   Box get profile => Hive.box(StorageKeys.profileBox);
   Box get settings => Hive.box(StorageKeys.settingsBox);
 }

 ---
 Step 8 — Session Store (Riverpod Provider)

 lib/src/core/session/session_store.dart

 Rewrite as a StateNotifier-based Riverpod provider:

 // SessionState: { accessToken?, refreshToken?, userId?, role?, isAuthenticated }
 // SessionNotifier: exposes login(AuthSession), logout(), restoreSession()
 // restoreSession(): reads tokens from SecureStorage, calls GET /me to validate,
 sets state
 // logout(): deletes all secure storage, clears hive profile box, state →
 unauthenticated
 // Emits to router stream so GoRouter can react to auth changes

 Exposed via: final sessionProvider = StateNotifierProvider<SessionNotifier,
 SessionState>(...)

 ---
 Step 9 — Router (Full GoRouter + Guards)

 lib/src/router/app_router.dart

 All 21+ routes with redirect guards. Pattern: routes are defined as string
 constants.

 abstract final class AppRoutes {
   static const splash          = '/splash';
   static const auth            = '/auth';
   static const emailLogin      = '/auth/email-login';
   static const otpLogin        = '/auth/otp';
   static const profileBootstrap = '/profile/bootstrap';
   static const home            = '/';
   static const search          = '/search';
   static const salonDetail     = '/salons/:salonId';
   static const favorites       = '/favorites';
   static const bookingService  = '/booking/service';
   static const bookingStaff    = '/booking/staff';
   static const bookingSlot     = '/booking/slot';
   static const bookingReview   = '/booking/review';
   static const bookingPayment  = '/booking/payment-handoff/:bookingId';
   static const bookingSuccess  = '/booking/success/:bookingId';
   static const bookingsList    = '/bookings';
   static const bookingDetail   = '/bookings/:bookingId';
   static const bookingManage   = '/bookings/:bookingId/manage';
   static const notifications   = '/notifications';
   static const profile         = '/profile';
   static const reviewNew       = '/reviews/new/:bookingId';
 }

 GoRouter config:
 - refreshListenable: listen to sessionProvider changes to trigger redirect
 evaluation
 - redirect: global guard — if not authenticated and route is protected → /auth; if
 authenticated and on /auth → /; if authenticated but profile incomplete →
 /profile/bootstrap
 - ShellRoute for bottom nav (home/bookings/profile tabs)
 - Booking funnel as full-screen GoRoute children (no shell)
 - All bookingId passed as path params, serviceId/staffId as query params

 ---
 Step 10 — Providers (Riverpod)

 Use riverpod_generator (@riverpod annotations). One file per feature provider.

 Auth providers

 - authProvider — AsyncNotifier<void>: login(email,pass), loginOtp(phone,code),
 logout, updateProfile
 - currentUserProvider — FutureProvider<CurrentUser?>: calls GET /me, cached

 Discovery providers

 - salonListProvider(SalonListParams) — FutureProvider: GET /salons with filters;
 caches in AppCache.salons
 - salonDetailProvider(String salonId) — FutureProvider<SalonDetail>
 - salonAvailabilityProvider(AvailabilityParams) —
 FutureProvider<List<AvailabilitySlot>>
 - salonReviewsProvider(String salonId) — FutureProvider
 - favoritesProvider — AsyncNotifier: add/remove/list favorites

 Booking funnel providers

 - bookingFunnelProvider — StateNotifier<BookingFunnelState>: step state machine
   - BookingFunnelState: { salonId, serviceId, employeeId?, slot?, depositAmount?,
 paymentId? }
   - Methods: selectService, selectEmployee, selectSlot, confirm, reset
 - bookingCreateProvider — AsyncNotifier<BookingSummary>: POST /bookings
 - paymentInitiateProvider — AsyncNotifier<PaymentInitiateResponse>: POST
 /payments/deposits/initiate

 Booking management providers

 - bookingsListProvider — FutureProvider<List<BookingSummary>>: GET /bookings; caches
  in hive
 - bookingDetailProvider(String bookingId) — FutureProvider<BookingSummary>
 - bookingCancelProvider — AsyncNotifier<void>
 - bookingRescheduleProvider — AsyncNotifier<void>

 Profile providers

 - profileProvider — AsyncNotifier<CurrentUser>: GET /me + PATCH /me

 Notification providers

 - notificationsProvider — AsyncNotifier<List<Notification>>: GET /notifications;
 cache hive
 - markReadProvider — AsyncNotifier<void>: POST /notifications/:id/read

 Connectivity

 - connectivityProvider — StreamProvider<ConnectivityResult>: uses connectivity_plus

 ---
 Step 11 — main.dart and app.dart

 lib/main.dart

 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();        // firebase_core
   await AppCache.init();                  // hive_ce boxes
   runApp(const ProviderScope(child: ClientApp()));
 }

 lib/src/app.dart

 // ScreenUtilInit wraps MaterialApp.router
 // Design size: 390 x 844 (iPhone 14 base)
 ScreenUtilInit(
   designSize: const Size(390, 844),
   minTextAdapt: true,
   splitScreenMode: true,
   builder: (context, child) => MaterialApp.router(
     title: 'Beauté Avenue',
     theme: AppTheme.light,
     darkTheme: AppTheme.dark,
     themeMode: ThemeMode.system,
     routerConfig: ref.watch(routerProvider),
     localizationsDelegates: const [
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
     supportedLocales: const [Locale('fr', 'SN')],
   ),
 )

 ---
 Step 12 — Views (Shells + Placeholders, then Full UI)

 Build in this order — each is a named file in lib/src/features/<feature>/pages/:

 Phase A — Shells and routing scaffolds (all compile, show loading/placeholder):
 1. SplashPage — CircularProgressIndicator, calls sessionProvider.restore()
 2. AuthChoicePage — two buttons using AppStrings, routes to email or OTP
 3. EmailLoginPage — Form with TextFormField (email + password), uses
 inputDecorationTheme
 4. OtpLoginPage — phone input → Pinput (6-digit), resend timer with intl
 5. ProfileBootstrapPage — full name + optional phone form
 6. ShellScaffold — bottom nav GoRouter shell (3 tabs)
 7. All remaining 16 pages as loading stubs (Scaffold + AppBar +
 CircularProgressIndicator)

 Phase B — Discovery (highest user value):
 8. HomePage — skeleton shimmer list, then SalonCard widgets
 9. SearchPage — filter chips, search field, result list
 10. SalonDetailPage — gallery, service list, CTA, maps handoff
 11. FavoritesPage — list with remove swipe

 Phase C — Booking funnel:
 12. ServiceSelectionPage — list of services with price/duration
 13. StaffSelectionPage — staff grid + "no preference" option
 14. SlotSelectionPage — day picker + time grid
 15. BookingReviewPage — summary card + confirm CTA
 16. PaymentHandoffPage — launch Wave/OrangeMoney URL via url_launcher
 17. BookingSuccessPage — success illustration + CTA

 Phase D — Management:
 18. BookingsListPage — upcoming + past tabs with shimmer
 19. BookingDetailPage — status timeline, action tray
 20. BookingManagePage — cancel/reschedule form
 21. ReviewNewPage — star rating + TextField
 22. NotificationsPage — list with read/unread states
 23. ProfilePage — edit form + logout

 ---
 Step 13 — Build Runner & Code Generation

 After all changes, run once:
 cd apps/mobile-client
 flutter pub run build_runner build --delete-conflicting-outputs

 This generates:
 - app_env.g.dart — envied constants
 - *.g.dart from @riverpod annotations
 - *.g.dart from generated openapi models (json_serializable)
 - *.freezed.dart if freezed models used

 ---
 Directory Layout (Final)

 apps/mobile-client/lib/
 ├── main.dart
 └── src/
     ├── app.dart
     ├── core/
     │   ├── constants/
     │   │   ├── app_strings.dart
     │   │   └── storage_keys.dart
     │   ├── env/
     │   │   ├── app_env.dart
     │   │   └── app_env.g.dart             ← generated
     │   ├── network/
     │   │   └── dio_client.dart
     │   ├── storage/
     │   │   ├── secure_storage.dart
     │   │   └── app_cache.dart
     │   ├── session/
     │   │   └── session_store.dart
     │   └── theme/
     │       ├── app_colors.dart
     │       ├── app_text_styles.dart
     │       ├── app_spacing.dart
     │       ├── app_shadows.dart
     │       └── app_theme.dart
     ├── generated/                          ← openapi-generator output
     │   └── lib/
     │       ├── api/
     │       └── model/
     ├── router/
     │   └── app_router.dart
     └── features/
         ├── auth/
         │   ├── providers/
         │   │   └── auth_provider.dart
         │   └── pages/
         │       ├── auth_choice_page.dart
         │       ├── email_login_page.dart
         │       ├── otp_login_page.dart
         │       └── profile_bootstrap_page.dart
         ├── discovery/
         │   ├── providers/
         │   │   ├── salon_list_provider.dart
         │   │   ├── salon_detail_provider.dart
         │   │   └── favorites_provider.dart
         │   └── pages/
         │       ├── home_page.dart
         │       ├── search_page.dart
         │       ├── salon_detail_page.dart
         │       └── favorites_page.dart
         ├── booking/
         │   ├── providers/
         │   │   ├── booking_funnel_provider.dart
         │   │   ├── booking_create_provider.dart
         │   │   └── payment_initiate_provider.dart
         │   └── pages/
         │       ├── service_selection_page.dart
         │       ├── staff_selection_page.dart
         │       ├── slot_selection_page.dart
         │       ├── booking_review_page.dart
         │       ├── payment_handoff_page.dart
         │       └── booking_success_page.dart
         ├── appointments/
         │   ├── providers/
         │   │   ├── bookings_list_provider.dart
         │   │   └── booking_detail_provider.dart
         │   └── pages/
         │       ├── bookings_list_page.dart
         │       ├── booking_detail_page.dart
         │       ├── booking_manage_page.dart
         │       └── review_new_page.dart
         ├── notifications/
         │   ├── providers/
         │   │   └── notifications_provider.dart
         │   └── pages/
         │       └── notifications_page.dart
         └── profile/
             ├── providers/
             │   └── profile_provider.dart
             └── pages/
                 └── profile_page.dart

 ---
 Verification

 # 1. Regenerate API spec (from repo root)
 pnpm openapi:generate

 # 2. Generate Flutter client code (from apps/mobile-client/)
 npx @openapitools/openapi-generator-cli generate \
   -i ../../apps/api/openapi/openapi.json \
   -g dart-dio -o lib/src/generated

 # 3. Install packages
 flutter pub get

 # 4. Build codegen artifacts
 flutter pub run build_runner build --delete-conflicting-outputs

 # 5. Type check (no errors)
 flutter analyze

 # 6. Run app on simulator/emulator
 flutter run

 # 7. Manual verification flow:
 #    a. Splash → auth choice
 #    b. Email login → home (skeleton loading)
 #    c. Tap salon → detail → select service → slot → review → confirm
 #    d. Check /bookings tab → see booking
 #    e. Profile tab → name edit
 #    f. Sign out → back to /auth

 ---
 Notes for Continuation (if context resets)

 - Do not write models manually — all types come from lib/src/generated/
 - Every string → AppStrings.xxx, never inline
 - Every color → AppColors.xxx, never Color(0xFF...)
 - Every font size → xx.sp, every width → xx.w, every height → xx.h, every radius →
 xx.r
 - Every storage key → StorageKeys.xxx, never raw strings
 - Every API URL → comes from generated client or AppEnv.apiBaseUrl
 - Packages for specific UI concerns: pinput (OTP), shimmer (skeleton),
 cached_network_image (photos), url_launcher (payment), intl (XOF formatting:
 NumberFormat.currency(locale: 'fr_SN', symbol: 'XOF'))
 - connectivity_plus drives the offline banner — all mutation routes check
 connectivityProvider before calling API
 - hive_ce stores list caches only; per-item detail can be re-fetched since it's
 cheap
 - flutter_secure_storage stores only auth tokens + userId (minimal sensitive
 surface)
 - Views are last — routing + providers must work first so navigation guards fire
 correctly
