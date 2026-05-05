import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_salon_list_items.dart';

class AppSalonListView extends StatelessWidget {
  final List<dynamic> items;
  final bool isStale;
  final DateTime? cachedAt;
  final Widget Function(BuildContext context, int index, dynamic item) itemBuilder;
  final Widget? emptyState;
  final EdgeInsets? padding;

  const AppSalonListView({
    required this.items,
    this.isStale = false,
    this.cachedAt,
    required this.itemBuilder,
    this.emptyState,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && emptyState != null) return emptyState!;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: padding ?? EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
          sliver: AppSalonListItems(
            items: items,
            isStale: isStale,
            cachedAt: cachedAt,
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
