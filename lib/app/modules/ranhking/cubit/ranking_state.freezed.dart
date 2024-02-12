// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RankingState {
  int get filter => throw _privateConstructorUsedError;
  List<User>? get usersday => throw _privateConstructorUsedError;
  List<User>? get usersMonth => throw _privateConstructorUsedError;
  List<User>? get usersYear => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Error? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RankingStateCopyWith<RankingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingStateCopyWith<$Res> {
  factory $RankingStateCopyWith(
          RankingState value, $Res Function(RankingState) then) =
      _$RankingStateCopyWithImpl<$Res, RankingState>;
  @useResult
  $Res call(
      {int filter,
      List<User>? usersday,
      List<User>? usersMonth,
      List<User>? usersYear,
      String? message,
      Error? error});
}

/// @nodoc
class _$RankingStateCopyWithImpl<$Res, $Val extends RankingState>
    implements $RankingStateCopyWith<$Res> {
  _$RankingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
    Object? usersday = freezed,
    Object? usersMonth = freezed,
    Object? usersYear = freezed,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as int,
      usersday: freezed == usersday
          ? _value.usersday
          : usersday // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      usersMonth: freezed == usersMonth
          ? _value.usersMonth
          : usersMonth // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      usersYear: freezed == usersYear
          ? _value.usersYear
          : usersYear // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Error?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RankingStateCopyWith<$Res>
    implements $RankingStateCopyWith<$Res> {
  factory _$$_RankingStateCopyWith(
          _$_RankingState value, $Res Function(_$_RankingState) then) =
      __$$_RankingStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int filter,
      List<User>? usersday,
      List<User>? usersMonth,
      List<User>? usersYear,
      String? message,
      Error? error});
}

/// @nodoc
class __$$_RankingStateCopyWithImpl<$Res>
    extends _$RankingStateCopyWithImpl<$Res, _$_RankingState>
    implements _$$_RankingStateCopyWith<$Res> {
  __$$_RankingStateCopyWithImpl(
      _$_RankingState _value, $Res Function(_$_RankingState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
    Object? usersday = freezed,
    Object? usersMonth = freezed,
    Object? usersYear = freezed,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(_$_RankingState(
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as int,
      usersday: freezed == usersday
          ? _value._usersday
          : usersday // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      usersMonth: freezed == usersMonth
          ? _value._usersMonth
          : usersMonth // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      usersYear: freezed == usersYear
          ? _value._usersYear
          : usersYear // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Error?,
    ));
  }
}

/// @nodoc

class _$_RankingState extends _RankingState {
  const _$_RankingState(
      {this.filter = 0,
      final List<User>? usersday,
      final List<User>? usersMonth,
      final List<User>? usersYear,
      this.message,
      this.error})
      : _usersday = usersday,
        _usersMonth = usersMonth,
        _usersYear = usersYear,
        super._();

  @override
  @JsonKey()
  final int filter;
  final List<User>? _usersday;
  @override
  List<User>? get usersday {
    final value = _usersday;
    if (value == null) return null;
    if (_usersday is EqualUnmodifiableListView) return _usersday;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<User>? _usersMonth;
  @override
  List<User>? get usersMonth {
    final value = _usersMonth;
    if (value == null) return null;
    if (_usersMonth is EqualUnmodifiableListView) return _usersMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<User>? _usersYear;
  @override
  List<User>? get usersYear {
    final value = _usersYear;
    if (value == null) return null;
    if (_usersYear is EqualUnmodifiableListView) return _usersYear;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? message;
  @override
  final Error? error;

  @override
  String toString() {
    return 'RankingState(filter: $filter, usersday: $usersday, usersMonth: $usersMonth, usersYear: $usersYear, message: $message, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RankingState &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality().equals(other._usersday, _usersday) &&
            const DeepCollectionEquality()
                .equals(other._usersMonth, _usersMonth) &&
            const DeepCollectionEquality()
                .equals(other._usersYear, _usersYear) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      filter,
      const DeepCollectionEquality().hash(_usersday),
      const DeepCollectionEquality().hash(_usersMonth),
      const DeepCollectionEquality().hash(_usersYear),
      message,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RankingStateCopyWith<_$_RankingState> get copyWith =>
      __$$_RankingStateCopyWithImpl<_$_RankingState>(this, _$identity);
}

abstract class _RankingState extends RankingState {
  const factory _RankingState(
      {final int filter,
      final List<User>? usersday,
      final List<User>? usersMonth,
      final List<User>? usersYear,
      final String? message,
      final Error? error}) = _$_RankingState;
  const _RankingState._() : super._();

  @override
  int get filter;
  @override
  List<User>? get usersday;
  @override
  List<User>? get usersMonth;
  @override
  List<User>? get usersYear;
  @override
  String? get message;
  @override
  Error? get error;
  @override
  @JsonKey(ignore: true)
  _$$_RankingStateCopyWith<_$_RankingState> get copyWith =>
      throw _privateConstructorUsedError;
}
