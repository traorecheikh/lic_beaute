import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

// ─── Variant catalogue ────────────────────────────────────────────────────────

enum SlotVariant {
  v1BlockFilter('1 · Blocs 2h'),
  v2PeriodSections('2 · Sections'),
  v3PillTabs('3 · Onglets'),
  v4HourLanes('4 · Couloirs H'),
  v5Accordion('5 · Accordéon'),
  v6PageCards('6 · Cartes'),
  v7Swimlanes('7 · Timeline'),
  v8ClearList('8 · Liste'),
  v9ColorChips('9 · Chips couleur'),
  v10PureGrid('10 · Grille pure');

  const SlotVariant(this.label);
  final String label;

  SlotVariant get next =>
      SlotVariant.values[(SlotVariant.values.indexOf(this) + 1) % SlotVariant.values.length];
  SlotVariant get prev =>
      SlotVariant.values[
        (SlotVariant.values.indexOf(this) - 1 + SlotVariant.values.length) %
            SlotVariant.values.length];
}

typedef OnSlotSelect = void Function(Map<String, dynamic> slot);

// ─── Shared helpers ───────────────────────────────────────────────────────────

DateTime _dt(Map<String, dynamic> s) =>
    DateTime.parse(s['startsAt'] as String).toLocal();

DateTime _endDt(Map<String, dynamic> s) =>
    DateTime.parse(s['endsAt'] as String).toLocal();

String _fmt(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

String _fmtDur(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h == 0) return '${m}min';
  if (m == 0) return '${h}h';
  return '${h}h${m.toString().padLeft(2, '0')}';
}

bool _chosen(Map<String, dynamic>? sel, Map<String, dynamic> s) =>
    sel?['startsAt'] == s['startsAt'];

enum _Period { matin, apresMidi, soir }

extension _PE on _Period {
  String get label => switch (this) {
        _Period.matin => 'Matin',
        _Period.apresMidi => 'Après-midi',
        _Period.soir => 'Soir',
      };
  String get icon => switch (this) {
        _Period.matin => '☀️',
        _Period.apresMidi => '⛅',
        _Period.soir => '🌙',
      };
  Color get color => switch (this) {
        _Period.matin => const Color(0xFFF59E0B),
        _Period.apresMidi => const Color(0xFF3B82F6),
        _Period.soir => const Color(0xFF8B5CF6),
      };
}

_Period _period(Map<String, dynamic> s) {
  final h = _dt(s).hour;
  if (h < 12) return _Period.matin;
  if (h < 17) return _Period.apresMidi;
  return _Period.soir;
}

Map<_Period, List<Map<String, dynamic>>> _byPeriod(List<Map<String, dynamic>> slots) {
  final m = <_Period, List<Map<String, dynamic>>>{for (final p in _Period.values) p: []};
  for (final s in slots) {
    m[_period(s)]!.add(s);
  }
  m.removeWhere((key, v) => v.isEmpty);
  return m;
}

Map<int, List<Map<String, dynamic>>> _by2h(List<Map<String, dynamic>> slots) {
  final m = <int, List<Map<String, dynamic>>>{};
  for (final s in slots) {
    final b = (_dt(s).hour ~/ 2) * 2;
    m.putIfAbsent(b, () => []).add(s);
  }
  return m;
}

Map<int, List<Map<String, dynamic>>> _byHour(List<Map<String, dynamic>> slots) {
  final m = <int, List<Map<String, dynamic>>>{};
  for (final s in slots) {
    m.putIfAbsent(_dt(s).hour, () => []).add(s);
  }
  return m;
}

Widget _chip(
  Map<String, dynamic> slot,
  Map<String, dynamic>? selected,
  OnSlotSelect onSelect, {
  Color? accent,
  EdgeInsetsGeometry? padding,
}) {
  final sel = _chosen(selected, slot);
  final color = accent ?? AppColors.primary;
  return GestureDetector(
    onTap: () => onSelect(slot),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: sel ? color : AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: sel ? color : AppColors.outlineVariant, width: sel ? 1.5 : 1),
        boxShadow: sel ? null : AppShadows.sm,
      ),
      child: Text(
        _fmt(_dt(slot)),
        style: AppTextStyles.labelMd.copyWith(
          color: sel ? AppColors.white : AppColors.onSurface,
        ),
      ),
    ),
  );
}

Widget _overline(String text) => Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );

// ─── Factory ──────────────────────────────────────────────────────────────────

Widget buildSlotVariant({
  required SlotVariant variant,
  required List<Map<String, dynamic>> slots,
  required Map<String, dynamic>? selected,
  required OnSlotSelect onSelect,
  required Key variantKey,
}) =>
    switch (variant) {
      SlotVariant.v1BlockFilter =>
        V1SlotBlockFilter(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v2PeriodSections =>
        V2SlotPeriodSections(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v3PillTabs =>
        V3SlotPillTabs(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v4HourLanes =>
        V4SlotHourLanes(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v5Accordion =>
        V5SlotAccordion(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v6PageCards =>
        V6SlotPageCards(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v7Swimlanes =>
        V7SlotSwimlanes(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v8ClearList =>
        V8SlotClearList(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v9ColorChips =>
        V9SlotColorChips(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
      SlotVariant.v10PureGrid =>
        V10SlotPureGrid(key: variantKey, slots: slots, selected: selected, onSelect: onSelect),
    };

// ─────────────────────────────────────────────────────────────────────────────
// V1 · 2-hour block pills → wrapped chip grid
// ─────────────────────────────────────────────────────────────────────────────

class V1SlotBlockFilter extends StatefulWidget {
  const V1SlotBlockFilter({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  State<V1SlotBlockFilter> createState() => _V1State();
}

class _V1State extends State<V1SlotBlockFilter> {
  int? _active;

  @override
  Widget build(BuildContext context) {
    final g = _by2h(widget.slots);

    // Show all 2h blocks in the range [minBlock..maxBlock] — gaps are grayed out.
    final occupied = g.keys.toList()..sort();
    final minB = occupied.first;
    final maxB = occupied.last;
    final allBlocks = <int>[for (int b = minB; b <= maxB; b += 2) b];

    // Default active = first block that actually has slots.
    final active = (_active != null && g.containsKey(_active))
        ? _active!
        : occupied.first;
    final visible = g[active]!;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      children: [
        _overline('Plage horaire'),
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: allBlocks.length,
            separatorBuilder: (context0, i0) => SizedBox(width: 8.w),
            itemBuilder: (_, i) {
              final b = allBlocks[i];
              final hasSlots = g.containsKey(b);
              final sel = active == b;
              return GestureDetector(
                onTap: hasSlots ? () => setState(() => _active = b) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primary
                        : hasSlots
                            ? AppColors.surface
                            : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: sel
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                    ),
                    boxShadow: (sel || !hasSlots) ? null : AppShadows.sm,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${b.toString().padLeft(2, '0')}h–${(b + 2).toString().padLeft(2, '0')}h',
                    style: AppTextStyles.labelMd.copyWith(
                      color: sel
                          ? AppColors.white
                          : hasSlots
                              ? AppColors.onSurface
                              : AppColors.onSurfaceVariant.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          '${visible.length} créneaux',
          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [for (final s in visible) _chip(s, widget.selected, widget.onSelect)],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V2 · Period sections (Matin / Après-midi / Soir) + horizontal chip rows
// ─────────────────────────────────────────────────────────────────────────────

class V2SlotPeriodSections extends StatelessWidget {
  const V2SlotPeriodSections({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  Widget build(BuildContext context) {
    final periods = _byPeriod(slots);
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      children: [
        for (final entry in periods.entries) ...[
          Row(children: [
            Text(entry.key.icon, style: const TextStyle(fontSize: 16)),
            SizedBox(width: 6.w),
            Text(
              entry.key.label.toUpperCase(),
              style: AppTextStyles.labelSm
                  .copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2),
            ),
            SizedBox(width: 6.w),
            Text(
              '${entry.value.length}',
              style: AppTextStyles.labelSm.copyWith(color: entry.key.color),
            ),
          ]),
          SizedBox(height: 10.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: entry.value.length,
              separatorBuilder: (context0, i0) => SizedBox(width: 8.w),
              itemBuilder: (_, i) => _chip(
                entry.value[i], selected, onSelect,
                accent: entry.key.color,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V3 · Segmented pill tabs + chip grid for the active period
// ─────────────────────────────────────────────────────────────────────────────

class V3SlotPillTabs extends StatefulWidget {
  const V3SlotPillTabs({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  State<V3SlotPillTabs> createState() => _V3State();
}

class _V3State extends State<V3SlotPillTabs> {
  _Period? _active;

  @override
  Widget build(BuildContext context) {
    final periods = _byPeriod(widget.slots);
    final available = periods.keys.toList();
    final active =
        (_active != null && periods.containsKey(_active)) ? _active! : available.first;
    final visible = periods[active]!;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      children: [
        Container(
          height: 46.h,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(23.r),
            boxShadow: AppShadows.sm,
          ),
          child: Row(
            children: [
              for (final p in available)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _active = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: active == p ? AppColors.onSurface : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: Text(
                          '${p.icon} ${p.label}',
                          style: AppTextStyles.labelMd.copyWith(
                            color:
                                active == p ? AppColors.surface : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          '${visible.length} créneaux · ${active.label}',
          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            for (final s in visible) _chip(s, widget.selected, widget.onSelect, accent: active.color),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V4 · Hour swimlanes — hour bubble on the left, chips scroll right
// ─────────────────────────────────────────────────────────────────────────────

class V4SlotHourLanes extends StatelessWidget {
  const V4SlotHourLanes({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  Widget build(BuildContext context) {
    final hours = _byHour(slots);
    final sortedH = hours.keys.toList()..sort();
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      itemCount: sortedH.length,
      itemBuilder: (_, i) {
        final h = sortedH[i];
        final hSlots = hours[h]!;
        final p = _period(hSlots.first);
        return Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: p.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${h.toString().padLeft(2, '0')}h',
                    style: AppTextStyles.labelSm.copyWith(color: p.color),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      for (int j = 0; j < hSlots.length; j++) ...[
                        _chip(hSlots[j], selected, onSelect, accent: p.color),
                        if (j < hSlots.length - 1) SizedBox(width: 8.w),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V5 · Accordion — expandable period cards (one open at a time)
// ─────────────────────────────────────────────────────────────────────────────

class V5SlotAccordion extends StatefulWidget {
  const V5SlotAccordion({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  State<V5SlotAccordion> createState() => _V5State();
}

class _V5State extends State<V5SlotAccordion> {
  _Period? _open;

  @override
  void initState() {
    super.initState();
    final p = _byPeriod(widget.slots);
    if (p.isNotEmpty) _open = p.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final periods = _byPeriod(widget.slots);
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      children: [
        for (final entry in periods.entries)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: _open == entry.key ? entry.key.color : AppColors.outlineVariant,
                  width: _open == entry.key ? 1.5 : 1,
                ),
                boxShadow: AppShadows.sm,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(
                        () => _open = _open == entry.key ? null : entry.key),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(children: [
                        Text(entry.key.icon, style: const TextStyle(fontSize: 18)),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(entry.key.label,
                              style: AppTextStyles.labelMd
                                  .copyWith(color: AppColors.onSurface)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: entry.key.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text('${entry.value.length}',
                              style: AppTextStyles.labelSm
                                  .copyWith(color: entry.key.color)),
                        ),
                        SizedBox(width: 8.w),
                        AnimatedRotation(
                          turns: _open == entry.key ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: AppIcon('chevron-down',
                              color: AppColors.onSurfaceVariant, size: 20),
                        ),
                      ]),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: _open != entry.key
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                for (final s in entry.value)
                                  _chip(s, widget.selected, widget.onSelect,
                                      accent: entry.key.color),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V6 · Swipeable period cards (PageView with dot indicator)
// ─────────────────────────────────────────────────────────────────────────────

class V6SlotPageCards extends StatefulWidget {
  const V6SlotPageCards({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  State<V6SlotPageCards> createState() => _V6State();
}

class _V6State extends State<V6SlotPageCards> {
  late final PageController _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final periods = _byPeriod(widget.slots);
    final entries = periods.entries.toList();

    return Column(
      children: [
        SizedBox(height: 12.h),
        // Period tab strip
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              for (int i = 0; i < entries.length; i++) ...[
                GestureDetector(
                  onTap: () {
                    setState(() => _page = i);
                    _ctrl.animateToPage(i,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeInOut);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
                    decoration: BoxDecoration(
                      color: _page == i
                          ? entries[i].key.color
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: _page == i
                            ? entries[i].key.color
                            : AppColors.outlineVariant,
                      ),
                      boxShadow: _page == i ? null : AppShadows.sm,
                    ),
                    child: Text(
                      '${entries[i].key.icon} ${entries[i].key.label}',
                      style: AppTextStyles.labelMd.copyWith(
                        color: _page == i ? AppColors.white : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                if (i < entries.length - 1) SizedBox(width: 8.w),
              ],
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: entries.length,
            itemBuilder: (_, i) {
              final entry = entries[i];
              return ListView(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
                children: [
                  Text(
                    '${entry.value.length} créneaux · ${entry.key.label}',
                    style:
                        AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      for (final s in entry.value)
                        _chip(s, widget.selected, widget.onSelect,
                            accent: entry.key.color),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V7 · Vertical timeline — hour nodes on a spine, chips to the right
// ─────────────────────────────────────────────────────────────────────────────

class V7SlotSwimlanes extends StatelessWidget {
  const V7SlotSwimlanes({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  Widget build(BuildContext context) {
    final hours = _byHour(slots);
    final sortedH = hours.keys.toList()..sort();
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 12.h, 20.w, 20.h),
      itemCount: sortedH.length,
      itemBuilder: (_, i) {
        final h = sortedH[i];
        final hSlots = hours[h]!;
        final p = _period(hSlots.first);
        final isFirst = i == 0;
        final isLast = i == sortedH.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 60.w,
                child: Column(children: [
                  if (!isFirst)
                    Expanded(
                        child: Center(
                            child: Container(width: 2, color: AppColors.outlineVariant))),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: p.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${h.toString().padLeft(2, '0')}h',
                          style: AppTextStyles.labelSm.copyWith(color: p.color)),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                        child: Center(
                            child: Container(width: 2, color: AppColors.outlineVariant))),
                ]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      for (final s in hSlots) _chip(s, selected, onSelect, accent: p.color),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V8 · Clear list — time + duration + period accent bar, radio indicator
// ─────────────────────────────────────────────────────────────────────────────

class V8SlotClearList extends StatelessWidget {
  const V8SlotClearList({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      itemCount: slots.length,
      separatorBuilder: (context0, i0) => SizedBox(height: 8.h),
      itemBuilder: (_, i) {
        final s = slots[i];
        final sel = _chosen(selected, s);
        final start = _dt(s);
        final end = _endDt(s);
        final dur = end.difference(start);
        final p = _period(s);
        return GestureDetector(
          onTap: () => onSelect(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: sel ? AppColors.onSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: sel ? AppColors.onSurface : AppColors.outlineVariant,
              ),
              boxShadow: sel ? null : AppShadows.sm,
            ),
            child: Row(children: [
              Container(
                width: 4.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: sel ? AppColors.surface.withValues(alpha: 0.35) : p.color,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fmt(start),
                      style: AppTextStyles.labelMd.copyWith(
                        color: sel ? AppColors.surface : AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Jusqu\'à ${_fmt(end)} · ${_fmtDur(dur)}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: sel
                            ? AppColors.surface.withValues(alpha: 0.65)
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppIcon(
                sel ? 'check-circle' : 'circle',
                color: sel ? AppColors.primary : AppColors.outlineVariant,
                size: 22,
              ),
            ]),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V9 · Color-coded flow chips — all slots as a Wrap, colored by period
// ─────────────────────────────────────────────────────────────────────────────

class V9SlotColorChips extends StatelessWidget {
  const V9SlotColorChips({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  Widget build(BuildContext context) {
    final periods = _byPeriod(slots);
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      children: [
        Wrap(
          spacing: 14.w,
          runSpacing: 4.h,
          children: [
            for (final p in periods.keys)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: p.color, shape: BoxShape.circle)),
                SizedBox(width: 5.w),
                Text('${p.icon} ${p.label}',
                    style: AppTextStyles.bodySm
                        .copyWith(color: AppColors.onSurfaceVariant)),
              ]),
          ],
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final s in slots) _chip(s, selected, onSelect, accent: _period(s).color),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// V10 · Pure 4-column grid — no grouping, maximum density, minimal chrome
// ─────────────────────────────────────────────────────────────────────────────

class V10SlotPureGrid extends StatelessWidget {
  const V10SlotPureGrid({
    required this.slots,
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selected;
  final OnSlotSelect onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.0,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: slots.length,
      itemBuilder: (_, i) => _chip(
        slots[i], selected, onSelect,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      ),
    );
  }
}
