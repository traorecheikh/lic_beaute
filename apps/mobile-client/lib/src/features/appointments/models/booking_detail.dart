/// Typed model for the booking detail API response (`GET /api/v1/bookings/:id`).
/// Replaces ad‑hoc `Map<String, dynamic>` access throughout the app.
class BookingDetail {
  const BookingDetail({
    required this.salonId,
    required this.serviceId,
    required this.salonName,
    required this.serviceName,
    required this.employeeName,
    required this.status,
    required this.depositPaymentStatus,
    this.totalAmountXof,
    this.depositAmountXof,
    this.depositPaidXof,
    this.startsAt,
    this.endsAt,
    this.salonAddress,
    this.durationMinutes,
    this.salonLogoUrl,
  });

  final String salonId;
  final String serviceId;
  final String salonName;
  final String serviceName;
  final String employeeName;
  final String status;
  final String depositPaymentStatus;
  final int? totalAmountXof;
  final int? depositAmountXof;
  final int? depositPaidXof;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? salonAddress;
  final int? durationMinutes;
  final String? salonLogoUrl;

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      salonId: (json['salonId'] as String?) ?? '',
      serviceId: (json['serviceId'] as String?) ?? '',
      salonName: (json['salonName'] as String?) ?? 'Salon',
      serviceName: (json['serviceName'] as String?) ?? 'Prestation',
      employeeName: (json['employeeName'] as String?) ?? 'Peu importe',
      status: (json['status'] as String?) ?? 'pending',
      depositPaymentStatus: (json['depositPaymentStatus'] as String?) ?? 'pending',
      totalAmountXof: (json['totalAmountXof'] as num?)?.toInt(),
      depositAmountXof: (json['depositAmountXof'] as num?)?.toInt(),
      depositPaidXof: (json['depositPaidXof'] as num?)?.toInt(),
      startsAt: json['startsAt'] == null
          ? null
          : DateTime.tryParse(json['startsAt'] as String)?.toLocal(),
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.tryParse(json['endsAt'] as String)?.toLocal(),
      salonAddress: json['salonAddress'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      salonLogoUrl: json['salonLogoUrl'] as String?,
    );
  }
}
