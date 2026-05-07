import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_list_utils.dart';

class AppSalonListItems extends StatelessWidget {
  const AppSalonListItems({
    required this.items,
    this.isStale = false,
    this.cachedAt,
    required this.itemBuilder,
    super.key,
  });

  final List<dynamic> items;
  final bool isStale;
  final DateTime? cachedAt;
  final Widget Function(BuildContext context, int index, dynamic item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: AppListUtils.getItemCount(items.length, isStale, cachedAt),
      separatorBuilder: (_, _) => gapH12,
      itemBuilder: (context, i) => AppListUtils.buildItem(
        context: context,
        index: i,
        items: items,
        isStale: isStale,
        cachedAt: cachedAt,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
