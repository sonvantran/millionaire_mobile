import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_state.freezed.dart';

@freezed
class StoreState with _$StoreState {
  const StoreState._();

  const factory StoreState({
    String? message,
    Error? error,
  }) = _StoreState;
}
