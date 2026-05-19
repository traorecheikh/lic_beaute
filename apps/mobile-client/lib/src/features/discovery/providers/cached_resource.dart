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

extension BookingMapExtension on CachedResource<Map<String, dynamic>> {
  String get salonId => (data?['salonId'] as String?) ?? '';
  String get serviceId => (data?['serviceId'] as String?) ?? '';
  String get salonName => (data?['salonName'] as String?) ?? 'Salon';
  String get serviceName => (data?['serviceName'] as String?) ?? 'Prestation';
  String get employeeName =>
      (data?['employeeName'] as String?) ?? 'Peu importe';
  String get status => (data?['status'] as String?) ?? 'pending';
  String get depositPaymentStatus =>
      (data?['depositPaymentStatus'] as String?) ?? 'pending';
  int? get priceXof => (data?['totalAmountXof'] as num?)?.toInt();
  int? get depositXof => (data?['depositAmountXof'] as num?)?.toInt();
  int? get depositPaidXof => (data?['depositPaidXof'] as num?)?.toInt();
  DateTime? get startsAt => data?['startsAt'] == null
      ? null
      : DateTime.tryParse(data?['startsAt'] as String)?.toLocal();
  DateTime? get endsAt => data?['endsAt'] == null
      ? null
      : DateTime.tryParse(data?['endsAt'] as String)?.toLocal();

  List<String> get _months => const [
    'jan',
    'fév',
    'mar',
    'avr',
    'mai',
    'jun',
    'jul',
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
