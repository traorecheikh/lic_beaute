import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_salon_list_items.dart';

class AppSliverSalonList extends StatelessWidget {
  final List<dynamic> items;
  final bool isStale;
  final DateTime? cachedAt;
  final Widget Function(BuildContext context, int index, dynamic item) itemBuilder;
  final EdgeInsets? padding;

  const AppSliverSalonList({
    required this.items,
    this.isStale = false,
    this.cachedAt,
    required this.itemBuilder,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
      sliver: AppSalonListItems(
        items: items,
        isStale: isStale,
        cachedAt: cachedAt,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
