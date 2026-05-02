// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_analytics_top_services_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProAnalyticsTopServicesInner extends ProAnalyticsTopServicesInner {
  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  final int bookingCount;

  factory _$ProAnalyticsTopServicesInner(
          [void Function(ProAnalyticsTopServicesInnerBuilder)? updates]) =>
      (ProAnalyticsTopServicesInnerBuilder()..update(updates))._build();

  _$ProAnalyticsTopServicesInner._(
      {required this.serviceId,
      required this.serviceName,
      required this.bookingCount})
      : super._();
  @override
  ProAnalyticsTopServicesInner rebuild(
          void Function(ProAnalyticsTopServicesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProAnalyticsTopServicesInnerBuilder toBuilder() =>
      ProAnalyticsTopServicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProAnalyticsTopServicesInner &&
        serviceId == other.serviceId &&
        serviceName == other.serviceName &&
        bookingCount == other.bookingCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, serviceId.hashCode);
    _$hash = $jc(_$hash, serviceName.hashCode);
    _$hash = $jc(_$hash, bookingCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProAnalyticsTopServicesInner')
          ..add('serviceId', serviceId)
          ..add('serviceName', serviceName)
          ..add('bookingCount', bookingCount))
        .toString();
  }
}

class ProAnalyticsTopServicesInnerBuilder
    implements
        Builder<ProAnalyticsTopServicesInner,
            ProAnalyticsTopServicesInnerBuilder> {
  _$ProAnalyticsTopServicesInner? _$v;

  String? _serviceId;
  String? get serviceId => _$this._serviceId;
  set serviceId(String? serviceId) => _$this._serviceId = serviceId;

  String? _serviceName;
  String? get serviceName => _$this._serviceName;
  set serviceName(String? serviceName) => _$this._serviceName = serviceName;

  int? _bookingCount;
  int? get bookingCount => _$this._bookingCount;
  set bookingCount(int? bookingCount) => _$this._bookingCount = bookingCount;

  ProAnalyticsTopServicesInnerBuilder() {
    ProAnalyticsTopServicesInner._defaults(this);
  }

  ProAnalyticsTopServicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _serviceId = $v.serviceId;
      _serviceName = $v.serviceName;
      _bookingCount = $v.bookingCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProAnalyticsTopServicesInner other) {
    _$v = other as _$ProAnalyticsTopServicesInner;
  }

  @override
  void update(void Function(ProAnalyticsTopServicesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProAnalyticsTopServicesInner build() => _build();

  _$ProAnalyticsTopServicesInner _build() {
    final _$result = _$v ??
        _$ProAnalyticsTopServicesInner._(
          serviceId: BuiltValueNullFieldError.checkNotNull(
              serviceId, r'ProAnalyticsTopServicesInner', 'serviceId'),
          serviceName: BuiltValueNullFieldError.checkNotNull(
              serviceName, r'ProAnalyticsTopServicesInner', 'serviceName'),
          bookingCount: BuiltValueNullFieldError.checkNotNull(
              bookingCount, r'ProAnalyticsTopServicesInner', 'bookingCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
