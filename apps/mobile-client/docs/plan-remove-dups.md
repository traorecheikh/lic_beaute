 Plan: Mobile Client — Widget Deduplication & Centralization                                                            
                                                        
 Context

 npx jscpd lib found 70 clones / 737 duplicated lines (5.27%) in the Flutter mobile client.
 The codebase has solid design tokens (AppColors, AppTextStyles, AppSpacing, AppShadows, AppRadius) and a handful of
 core widgets, but no composite widget layer. Every feature page reinvents the same 6-8 UI assemblies inline. Three
 features (appointments, notifications, profile) have no widgets/ subfolder at all, so complex private widgets live
 inside page files and get copy-pasted across siblings.

 Goal: eliminate the detected clones, prevent future drift, and make each page file trivially short.

 ---
 Architecture Decision

 Two levels of shared widgets:

 1. Global → lib/src/core/widgets/ — used across ≥ 2 features
 2. Feature-local → lib/src/features/<feature>/widgets/ — used only within that feature

 ---
 Phase A — New Global Core Widgets

 All files go in lib/src/core/widgets/.

 A1. app_back_button.dart — AppBackButton

 Replaces the recurring transparent-AppBar leading pattern:
 AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(
   icon: Icon(Icons.arrow_back_ios_new, size: 20.w, color: AppColors.onSurface),
   onPressed: () => context.pop(),
 ))
 - Params: VoidCallback? onPressed (defaults to context.pop()), Color? color
 - Renders: IconButton with Icons.arrow_back_ios_new, size 20.w
 - Used in: email_login_page, otp_login_page, every future page with back nav

 A2. app_icon_box.dart — AppIconBox

 Replaces the recurring colored-container-with-icon pattern (6 occurrences, 4 files):
 Container(width: N.r, height: N.r,
   decoration: BoxDecoration(color: C, borderRadius/shape: ..., boxShadow: ...),
   child: Center(child: AppIcon(...) / Icon(...)))
 - Params: double size, Color color, Widget child, bool circle = false, List<BoxShadow>? shadow, BorderRadius? radius
 - Defaults: size: 36.r, color: AppColors.primaryLight, radius: BorderRadius.circular(10.r)
 - Used in: booking_detail_page, review_new_page, bookings_list_page, app_empty_state, app_error_state, support_page,
 payment_methods_page

 A3. app_bottom_bar.dart — AppBottomBar

 Replaces the recurring bottom action container + shadow (3 occurrences):
 Container(
   decoration: BoxDecoration(color: AppColors.surface,
     boxShadow: [BoxShadow(color: ..., blurRadius: 24, offset: Offset(0, -4))]),
   padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
   child: SafeArea(top: false, child: child))
 - Params: required Widget child, Color? backgroundColor, EdgeInsets? padding
 - Defaults to the standard shadow and fromLTRB(20.w, 14.h, 20.w, 0) padding
 - Used in: booking_detail_page, review_new_page, salon_detail_page

 A4. app_sheet_content.dart — AppSheetContent

 Replaces the recurring bottom-sheet body wrapper (4 occurrences in app_snackbar + shell_scaffold):
 SafeArea(top: false, child: Padding(
   padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
   child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
     children: [title widget, body widget, 24h gap, primary button, 10h gap, secondary button])))
 - Params: required String title, required String body, required String confirmLabel,
 String cancelLabel = 'Annuler', required VoidCallback onConfirm, VoidCallback? onCancel, bool destructive = false
 - Used in: app_snackbar.confirmDestructive, shell_scaffold auth prompt

 A5. app_badge.dart — AppBadge

 Replaces the recurring pill label (2+ files, inconsistent):
 Container(
   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
     borderRadius: BorderRadius.circular(20.r)),
   child: Text(label, style: AppTextStyles.labelSm.copyWith(color: color, fontSize: 10.sp)))
 - Params: required String label, required Color color, double? fontSize
 - Used in: payment_methods_page._Badge, salon_detail_page category badge

 A6. app_async_view.dart — AppAsyncView<T>

 Replaces the 6-file repeated AsyncValue.when loading/error/data pattern:
 asyncValue.when(
   loading: () => const Center(child: CircularProgressIndicator()),
   error: (error, _) => Padding(padding: EdgeInsets.all(24.r),
     child: AppErrorState(error: error, fallbackTitle: ..., onRetry: ...)),
   data: (data) => builder(data),
 )
 - Generic widget: AppAsyncView<T>
 - Params: required AsyncValue<T> value, required Widget Function(T) builder,
 String? errorTitle, String? serverTitle, Future<void> Function()? onRetry,
 Widget? loadingWidget, bool sliver = false
 - Used in: service_selection_page, staff_selection_page, salon_detail_page,
 search_page, payment_methods_page, support_page, bookings_list_page, notifications_page

 A7. app_selectable_card.dart — AppSelectableCard

 Replaces the 2-file selectable-card-with-border-highlight (65 lines each):
 Container(margin: EdgeInsets.only(bottom: 16.h), padding: EdgeInsets.all(16.w),
   decoration: BoxDecoration(color: colorScheme.surface,
     borderRadius: BorderRadius.circular(20.r),
     border: Border.all(color: isSelected ? primary : outlineVariant, width: isSelected ? 2 : 1)),
   child: child)
 - Params: required Widget child, required bool selected, required VoidCallback onTap,
 EdgeInsets? margin, EdgeInsets? padding
 - Used in: service_selection_page, staff_selection_page

 A8. app_carousel_dots.dart — AppCarouselDots

 Replaces the 2-instance page-dot indicator in salon_detail_page (220ms vs 200ms, ScreenUtil vs raw):
 - Params: required int count, required int current, Color activeColor = Colors.white,
 Color inactiveColor = Colors.white54, double activeDuration = 220
 - Used in: hero image SliverAppBar and _GalleryViewerState inside salon_detail_page

 A9. app_section_label.dart — AppSectionLabel

 Replaces inconsistent section-header pattern (extracted in salon_detail but inline elsewhere):
 - Params: required String text, TextStyle? style
 - Default: AppTextStyles.headlineSm
 - Used in: salon_detail_page._SectionLabel, support_page, profile_page

 ---
 Phase B — Create Missing Feature widgets/ Folders

 B1. appointments/widgets/

 Extract from booking_detail_page.dart:
 - booking_info_row.dart — BookingInfoRow(icon, label, value) (lines 369–393, cloned in review_new_page)
 - booking_status_chip.dart — BookingStatusChip(status) (cloned in bookings_list_page)

 Extract from bookings_list_page.dart:
 - booking_list_tile.dart — BookingListTile(booking) (lines 60–140, the card rendered per booking)

 B2. profile/widgets/

 Extract from payment_methods_page.dart:
 - payment_tile.dart — PaymentTile(method, onSetDefault, onDelete) (lines 249–364)

 Extract from support_page.dart:
 - support_tile.dart — SupportTile(icon, label, subtitle, onTap) (lines 93–154)

 Extract from faq_page.dart + support_page.dart (cloned pattern):
 - faq_tile.dart — FaqTile(question, answer) (cloned at faq_page:67-98, support_page:159-192)

 Extract from addresses_page.dart + memberships_page.dart (cloned empty-list pattern):
 - already covered by AppEmptyState — replace inline recreations

 B3. notifications/widgets/

 Extract from notifications_page.dart:
 - notification_tile.dart — NotificationTile(notification) (lines 99–118, cloned with payment_methods pattern)

 ---
 Phase C — Replace Inline Hardcoded Values

 Sweep the following anti-patterns after new widgets are in place:

 ┌───────────────────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
 │                         Anti-pattern                          │                  Replace with                   │
 ├───────────────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
 │ SizedBox(height: 8.h) in spacing chains                       │ AppSpacing.sm via Gap(AppSpacing.sm) or         │
 │                                                               │ SizedBox(height: AppSpacing.sm.h)               │
 ├───────────────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
 │ BorderRadius.circular(20.r) on cards                          │ AppRadius.lg                                    │
 ├───────────────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
 │ BorderRadius.circular(16.r) on inputs                         │ AppRadius.md                                    │
 ├───────────────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
 │ Color(0xFF...) hardcoded literals                             │ AppColors.*                                     │
 ├───────────────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
 │ Container(width: 36.r, height: 36.r, decoration:              │ AppIconBox(circle: true, ...)                   │
 │ BoxDecoration(shape: BoxShape.circle ...))                    │                                                 │
 ├───────────────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
 │ appBar: AppBar(backgroundColor: Colors.transparent,           │ appBar: AppBar(leading: AppBackButton())        │
 │ elevation: 0, leading: IconButton(...))                       │                                                 │
 └───────────────────────────────────────────────────────────────┴─────────────────────────────────────────────────┘

 ---
 Execution Order

 A6 AppAsyncView         ← highest ROI (6 clones, used everywhere)
 A3 AppBottomBar         ← 3 clones, booking + review + salon
 A2 AppIconBox           ← 6 occurrences
 A4 AppSheetContent      ← snackbar + scaffold refactor
 A7 AppSelectableCard    ← booking funnel simplification
 A1 AppBackButton        ← auth pages
 A5 AppBadge             ← profile + discovery
 A8 AppCarouselDots      ← salon detail
 A9 AppSectionLabel      ← various
 B1 appointments/widgets/
 B2 profile/widgets/
 B3 notifications/widgets/
 Phase C hardcoded-value sweep

 ---
 Critical Files to Modify

 - lib/src/features/booking/pages/service_selection_page.dart — A6, A7, A3
 - lib/src/features/booking/pages/staff_selection_page.dart — A6, A7, A3
 - lib/src/features/discovery/pages/salon_detail_page.dart — A3, A8, A9
 - lib/src/features/discovery/pages/search_page.dart — A6
 - lib/src/features/profile/pages/payment_methods_page.dart — A5, A6, B2
 - lib/src/features/profile/pages/support_page.dart — A6, A9, B2
 - lib/src/features/profile/pages/faq_page.dart — B2
 - lib/src/features/appointments/pages/booking_detail_page.dart — A2, A3, B1
 - lib/src/features/appointments/pages/review_new_page.dart — A2, A3, B1
 - lib/src/features/appointments/pages/bookings_list_page.dart — A6, B1
 - lib/src/features/auth/pages/email_login_page.dart — A1
 - lib/src/features/auth/pages/otp_login_page.dart — A1
 - lib/src/features/notifications/pages/notifications_page.dart — A6, B3
 - lib/src/router/shell_scaffold.dart — A4
 - lib/src/core/widgets/app_snackbar.dart — A4
 - lib/src/core/widgets/app_empty_state.dart — A2
 - lib/src/core/widgets/app_error_state.dart — A2

 ---
 Verification

 After each phase:
 cd apps/mobile-client
 flutter analyze        # no new analysis issues
 flutter test           # all existing tests pass
 npx jscpd lib --min-lines 5 --min-tokens 40 --reporters console  # clone count drops

 Target: reduce 70 clones → < 20 (unavoidable structural patterns).

 After Phase B (profile/widgets), run jscpd again — profile alone accounts for ~18 of the 70 clones.
