import 'package:beauteavenue_api/beauteavenue_api.dart';

/// Typed model for the booking detail API response (`GET /api/v1/bookings/:id`).
/// Fields match what the backend actually returns via bookingSummary() plus
/// the review-state additions. Fields the backend never returns have been removed.
class BookingDetail {
  const BookingDetail({
    required this.salonId,
    required this.serviceId,
    required this.salonName,
    required this.serviceName,
    required this.status,
    required this.depositPaymentStatus,
    this.depositAmountXof,
    this.depositPaidXof,
    this.startsAt,
    this.endsAt,
    this.salonLogoUrl,
    this.reviewId,
    this.employeeName = 'Peu importe',
    this.salonAddress = '',
    this.durationMinutes = 45,
    this.totalAmountXof,
  });

  final String salonId;
  final String serviceId;
  final String salonName;
  final String serviceName;
  final String status;
  final String depositPaymentStatus;
  final int? depositAmountXof;
  final int? depositPaidXof;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? salonLogoUrl;
  final String? reviewId;
  final String employeeName;
  final String salonAddress;
  final int durationMinutes;
  final int? totalAmountXof;

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      salonId: (json['salonId'] as String?) ?? '',
      serviceId: (json['serviceId'] as String?) ?? '',
      salonName: (json['salonName'] as String?) ?? 'Salon',
      serviceName: (json['serviceName'] as String?) ?? 'Prestation',
      status: (json['status'] as String?) ?? 'pending',
      depositPaymentStatus: (json['depositPaymentStatus'] as String?) ?? 'pending',
      depositAmountXof: (json['depositAmountXof'] as num?)?.toInt(),
      depositPaidXof: (json['depositPaidXof'] as num?)?.toInt(),
      startsAt: json['startsAt'] == null
          ? null
          : DateTime.tryParse(json['startsAt'] as String)?.toLocal(),
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.tryParse(json['endsAt'] as String)?.toLocal(),
      salonLogoUrl: json['salonLogoUrl'] as String?,
      reviewId: json['reviewId'] as String?,
      employeeName: (json['employeeName'] as String?) ?? 'Peu importe',
      salonAddress: (json['salonAddress'] as String?) ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 45,
      totalAmountXof: (json['totalAmountXof'] as num?)?.toInt(),
    );
  }

  /// Create a BookingDetail from the generated [BookingSummary] model.
  /// This keeps the fetch in the contract regeneration path while preserving
  /// the convenience methods on [BookingDetail].
  factory BookingDetail.fromSummary(BookingSummary summary) {
    return BookingDetail(
      salonId: summary.salonId,
      serviceId: summary.serviceId,
      salonName: summary.salonName,
      serviceName: summary.serviceName,
      status: summary.status.name,
      depositPaymentStatus: summary.depositPaymentStatus.name,
      depositAmountXof: summary.depositAmountXof.toInt(),
      depositPaidXof: summary.depositPaidXof?.toInt(),
      startsAt: summary.startsAt.toLocal(),
      endsAt: summary.endsAt.toLocal(),
      salonLogoUrl: summary.salonLogoUrl,
      reviewId: summary.reviewId,
    );
  }

  bool get hasReview => (reviewId?.isNotEmpty ?? false);
}
