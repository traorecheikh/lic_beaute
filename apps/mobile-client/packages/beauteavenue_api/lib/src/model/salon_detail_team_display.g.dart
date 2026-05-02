// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_detail_team_display.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalonDetailTeamDisplay extends SalonDetailTeamDisplay {
  @override
  final bool showPhotos;
  @override
  final bool showDescriptions;

  factory _$SalonDetailTeamDisplay(
          [void Function(SalonDetailTeamDisplayBuilder)? updates]) =>
      (SalonDetailTeamDisplayBuilder()..update(updates))._build();

  _$SalonDetailTeamDisplay._(
      {required this.showPhotos, required this.showDescriptions})
      : super._();
  @override
  SalonDetailTeamDisplay rebuild(
          void Function(SalonDetailTeamDisplayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalonDetailTeamDisplayBuilder toBuilder() =>
      SalonDetailTeamDisplayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalonDetailTeamDisplay &&
        showPhotos == other.showPhotos &&
        showDescriptions == other.showDescriptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, showPhotos.hashCode);
    _$hash = $jc(_$hash, showDescriptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalonDetailTeamDisplay')
          ..add('showPhotos', showPhotos)
          ..add('showDescriptions', showDescriptions))
        .toString();
  }
}

class SalonDetailTeamDisplayBuilder
    implements Builder<SalonDetailTeamDisplay, SalonDetailTeamDisplayBuilder> {
  _$SalonDetailTeamDisplay? _$v;

  bool? _showPhotos;
  bool? get showPhotos => _$this._showPhotos;
  set showPhotos(bool? showPhotos) => _$this._showPhotos = showPhotos;

  bool? _showDescriptions;
  bool? get showDescriptions => _$this._showDescriptions;
  set showDescriptions(bool? showDescriptions) =>
      _$this._showDescriptions = showDescriptions;

  SalonDetailTeamDisplayBuilder() {
    SalonDetailTeamDisplay._defaults(this);
  }

  SalonDetailTeamDisplayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _showPhotos = $v.showPhotos;
      _showDescriptions = $v.showDescriptions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalonDetailTeamDisplay other) {
    _$v = other as _$SalonDetailTeamDisplay;
  }

  @override
  void update(void Function(SalonDetailTeamDisplayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalonDetailTeamDisplay build() => _build();

  _$SalonDetailTeamDisplay _build() {
    final _$result = _$v ??
        _$SalonDetailTeamDisplay._(
          showPhotos: BuiltValueNullFieldError.checkNotNull(
              showPhotos, r'SalonDetailTeamDisplay', 'showPhotos'),
          showDescriptions: BuiltValueNullFieldError.checkNotNull(
              showDescriptions, r'SalonDetailTeamDisplay', 'showDescriptions'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
