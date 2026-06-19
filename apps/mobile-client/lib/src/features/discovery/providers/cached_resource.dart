import '../../appointments/models/booking_detail.dart';

class CachedResource<T> {
  const CachedResource({
    required this.data,
    required this.isStale,
    this.cachedAt,
  });

  final T? data;
  final bool isStale;
  final DateTime? cachedAt;
}

extension BookingMapExtension on CachedResource<BookingDetail> {
  String get salonId => data?.salonId ?? '';
  String get serviceId => data?.serviceId ?? '';
  String get salonName => data?.salonName ?? 'Salon';
  String get serviceName => data?.serviceName ?? 'Prestation';
  String get employeeName => data?.employeeName ?? 'Peu importe';
  String get status => data?.status ?? 'pending';
  String get depositPaymentStatus => data?.depositPaymentStatus ?? 'pending';
  int? get priceXof => data?.totalAmountXof;
  int? get depositXof => data?.depositAmountXof;
  int? get depositPaidXof => data?.depositPaidXof;
  DateTime? get startsAt => data?.startsAt;
  DateTime? get endsAt => data?.endsAt;

  List<String> get _months => const [
    'jan',
    'fév',
    'mar',
    'avr',
    'mai',
    'juin',
    'juil',
    'aoû',
    'sep',
    'oct',
    'nov',
    'déc',
  ];

  String get formattedDate {
    final dt = startsAt;
    if (dt == null) return '';
    return '${dt.day} ${_months[dt.month - 1]} · ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String get fullFormattedDate {
    final dt = startsAt;
    if (dt == null) return '';
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    return '${days[dt.weekday - 1]} ${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  String get formattedTime {
    final dt = startsAt;
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
