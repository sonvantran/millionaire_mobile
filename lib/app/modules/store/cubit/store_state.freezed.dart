// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$StoreState {
  User? get user => throw _privateConstructorUsedError;
  Store? get store => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Error? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StoreStateCopyWith<StoreState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreStateCopyWith<$Res> {
  factory $StoreStateCopyWith(
          StoreState value, $Res Function(StoreState) then) =
      _$StoreStateCopyWithImpl<$Res, StoreState>;
  @useResult
  $Res call({User? user, Store? store, String? message, Error? error});
}

/// @nodoc
class _$StoreStateCopyWithImpl<$Res, $Val extends StoreState>
    implements $StoreStateCopyWith<$Res> {
  _$StoreStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? store = freezed,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      store: freezed == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store?,
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
abstract class _$$_StoreStateCopyWith<$Res>
    implements $StoreStateCopyWith<$Res> {
  factory _$$_StoreStateCopyWith(
          _$_StoreState value, $Res Function(_$_StoreState) then) =
      __$$_StoreStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User? user, Store? store, String? message, Error? error});
}

/// @nodoc
class __$$_StoreStateCopyWithImpl<$Res>
    extends _$StoreStateCopyWithImpl<$Res, _$_StoreState>
    implements _$$_StoreStateCopyWith<$Res> {
  __$$_StoreStateCopyWithImpl(
      _$_StoreState _value, $Res Function(_$_StoreState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? store = freezed,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(_$_StoreState(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      store: freezed == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store?,
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

class _$_StoreState extends _StoreState {
  const _$_StoreState({this.user, this.store, this.message, this.error})
      : super._();

  @override
  final User? user;
  @override
  final Store? store;
  @override
  final String? message;
  @override
  final Error? error;

  @override
  String toString() {
    return 'StoreState(user: $user, store: $store, message: $message, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoreState &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, store, message, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoreStateCopyWith<_$_StoreState> get copyWith =>
      __$$_StoreStateCopyWithImpl<_$_StoreState>(this, _$identity);
}

abstract class _StoreState extends StoreState {
  const factory _StoreState(
      {final User? user,
      final Store? store,
      final String? message,
      final Error? error}) = _$_StoreState;
  const _StoreState._() : super._();

  @override
  User? get user;
  @override
  Store? get store;
  @override
  String? get message;
  @override
  Error? get error;
  @override
  @JsonKey(ignore: true)
  _$$_StoreStateCopyWith<_$_StoreState> get copyWith =>
      throw _privateConstructorUsedError;
}
