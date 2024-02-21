import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/model/item_model.dart';

part 'store_state.freezed.dart';

@freezed
class StoreState with _$StoreState {
  const StoreState._();

  const factory StoreState({
    Store? store,
    String? message,
    Error? error,
  }) = _StoreState;
}
