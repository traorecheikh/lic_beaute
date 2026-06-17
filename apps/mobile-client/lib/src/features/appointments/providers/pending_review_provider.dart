import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_store.dart';
import '../utils/review_prompt_manager.dart';
import 'bookings_list_provider.dart';

/// A pending review candidate ready for a proactive prompt.
class PendingReviewBooking {
  const PendingReviewBooking({
    required this.bookingId,
    required this.salonName,
    required this.serviceName,
    this.logoUrl,
  });

  final String bookingId;
  final String salonName;
  final String serviceName;
  final String? logoUrl;
}

/// Returns the first past booking that:
///   1. Has status `completed` or `endsAt` is in the past
///   2. Still has prompt budget (ReviewPromptManager.shouldPrompt)
///
/// Note: We cannot check server-side `reviewId` from the list endpoint
/// (the field is not in BookingSummaryListResponseItemsInner), so we rely on
/// the debounce manager's permanent-suppress flag, which is set as soon as
/// the user submits a review from any surface.
///
/// Returns `null` when there is nothing to prompt.
final pendingReviewProvider =
    FutureProvider.autoDispose<PendingReviewBooking?>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return null;

  final resource = await ref.watch(bookingsListProvider.future);
  final items = resource.data?.items.toList() ?? [];

  for (final b in items) {
    // API requires status == completed to accept a review.
    // Bookings that are past endsAt but still pending have not been
    // officially closed by the salon — no review yet.
    final isCompleted =
        b.status == BookingSummaryListResponseItemsInnerStatusEnum.completed;
    if (!isCompleted) continue;
    if (!ReviewPromptManager.shouldPrompt(b.id)) continue;

    return PendingReviewBooking(
      bookingId: b.id,
      salonName: b.salonName,
      serviceName: b.serviceName,
      logoUrl: b.salonLogoUrl,
    );
  }

  return null;
});
