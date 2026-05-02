// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_salon_update_input_team_display.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSalonUpdateInputTeamDisplay extends ProSalonUpdateInputTeamDisplay {
  @override
  final bool? showPhotos;
  @override
  final bool? showDescriptions;

  factory _$ProSalonUpdateInputTeamDisplay(
          [void Function(ProSalonUpdateInputTeamDisplayBuilder)? updates]) =>
      (ProSalonUpdateInputTeamDisplayBuilder()..update(updates))._build();

  _$ProSalonUpdateInputTeamDisplay._({this.showPhotos, this.showDescriptions})
      : super._();
  @override
  ProSalonUpdateInputTeamDisplay rebuild(
          void Function(ProSalonUpdateInputTeamDisplayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSalonUpdateInputTeamDisplayBuilder toBuilder() =>
      ProSalonUpdateInputTeamDisplayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSalonUpdateInputTeamDisplay &&
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
    return (newBuiltValueToStringHelper(r'ProSalonUpdateInputTeamDisplay')
          ..add('showPhotos', showPhotos)
          ..add('showDescriptions', showDescriptions))
        .toString();
  }
}

class ProSalonUpdateInputTeamDisplayBuilder
    implements
        Builder<ProSalonUpdateInputTeamDisplay,
            ProSalonUpdateInputTeamDisplayBuilder> {
  _$ProSalonUpdateInputTeamDisplay? _$v;

  bool? _showPhotos;
  bool? get showPhotos => _$this._showPhotos;
  set showPhotos(bool? showPhotos) => _$this._showPhotos = showPhotos;

  bool? _showDescriptions;
  bool? get showDescriptions => _$this._showDescriptions;
  set showDescriptions(bool? showDescriptions) =>
      _$this._showDescriptions = showDescriptions;

  ProSalonUpdateInputTeamDisplayBuilder() {
    ProSalonUpdateInputTeamDisplay._defaults(this);
  }

  ProSalonUpdateInputTeamDisplayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _showPhotos = $v.showPhotos;
      _showDescriptions = $v.showDescriptions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSalonUpdateInputTeamDisplay other) {
    _$v = other as _$ProSalonUpdateInputTeamDisplay;
  }

  @override
  void update(void Function(ProSalonUpdateInputTeamDisplayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSalonUpdateInputTeamDisplay build() => _build();

  _$ProSalonUpdateInputTeamDisplay _build() {
    final _$result = _$v ??
        _$ProSalonUpdateInputTeamDisplay._(
          showPhotos: showPhotos,
          showDescriptions: showDescriptions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
