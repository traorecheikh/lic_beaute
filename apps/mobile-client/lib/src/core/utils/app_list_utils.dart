import 'package:flutter/material.dart';
import '../../features/discovery/widgets/stale_data_notice.dart';

abstract final class AppListUtils {
  static int getItemCount(int itemCount, bool isStale, DateTime? cachedAt) {
    return itemCount + (isStale && cachedAt != null ? 1 : 0);
  }

  static Widget buildItem({
    required BuildContext context,
    required int index,
    required List<dynamic> items,
    required bool isStale,
    required DateTime? cachedAt,
    required Widget Function(BuildContext context, int index, dynamic item) itemBuilder,
  }) {
    int i = index;
    if (isStale && cachedAt != null) {
      if (i == 0) return StaleDataNotice(cachedAt: cachedAt);
      i -= 1;
    }
    return itemBuilder(context, i, items[i]);
  }
}
