import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beauteavenue_api/beauteavenue_api.dart';

import '../../discovery/providers/salon_detail_provider.dart';

class StaffLoadScore {
  StaffLoadScore({required this.staffId});

  final String staffId;
  int totalSlots = 0;
  int availableDays = 0;
  DateTime? earliest;
}

String ymdDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Probes each staff candidate's availability over the next [horizonDays]
/// and returns the staff id with the best availability (most days with slots,
/// then most total slots, then earliest slot).
Future<String?> resolveBestStaffId({
  required WidgetRef ref,
  required String salonId,
  required String serviceId,
  required SalonDetail salon,
}) async {
  const horizonDays = 5;

  final candidates = salon.staff
      .where(
        (s) => s.serviceIds.contains(serviceId) || s.serviceIds.isEmpty,
      )
      .toList();
  if (candidates.isEmpty) return null;

  final scores = <String, StaffLoadScore>{
    for (final s in candidates) s.id: StaffLoadScore(staffId: s.id),
  };

  for (var dayOffset = 1; dayOffset <= horizonDays; dayOffset++) {
    final probeDate = DateTime.now().add(Duration(days: dayOffset));
    final date = ymdDate(probeDate);

    final daySamples = await Future.wait(
      candidates.map((staff) async {
        final params = (
          salonId: salonId,
          date: date,
          serviceId: serviceId,
          employeeId: staff.id,
        );
        try {
          final slots = await ref.read(
            salonAvailabilityProvider(params).future,
          );
          return (staffId: staff.id, slots: slots);
        } catch (_) {
          return (staffId: staff.id, slots: const <dynamic>[]);
        }
      }),
    );

    for (final sample in daySamples) {
      final slotMaps = sample.slots.whereType<Map<String, dynamic>>().toList();
      final score = scores[sample.staffId];
      if (score == null || slotMaps.isEmpty) continue;

      score.totalSlots += slotMaps.length;
      score.availableDays += 1;
      final dayEarliest = slotMaps
          .map((slot) => slot['startsAt'] as String?)
          .whereType<String>()
          .fold<DateTime?>(null, (earliest, startsAt) {
            final parsed = DateTime.tryParse(startsAt);
            if (parsed == null) return earliest;
            if (earliest == null || parsed.isBefore(earliest)) return parsed;
            return earliest;
          });
      if (dayEarliest != null &&
          (score.earliest == null || dayEarliest.isBefore(score.earliest!))) {
        score.earliest = dayEarliest;
      }
    }
  }

  final ranked = scores.values.toList()
    ..sort((a, b) {
      final byDays = b.availableDays.compareTo(a.availableDays);
      if (byDays != 0) return byDays;
      final bySlots = b.totalSlots.compareTo(a.totalSlots);
      if (bySlots != 0) return bySlots;
      final aEarliest = a.earliest;
      final bEarliest = b.earliest;
      if (aEarliest != null && bEarliest != null) {
        final byEarliest = aEarliest.compareTo(bEarliest);
        if (byEarliest != 0) return byEarliest;
      } else if (aEarliest != null) {
        return -1;
      } else if (bEarliest != null) {
        return 1;
      }
      return a.staffId.compareTo(b.staffId);
    });

  return ranked.firstOrNull?.staffId;
}
