import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/model/user.dart';

part 'ranking_state.freezed.dart';

@freezed
class RankingState with _$RankingState {
  const RankingState._();

  const factory RankingState({
    @Default(0) int filter,
    List<User>? usersday,
    List<User>? usersMonth,
    List<User>? usersYear,
    Error? error,
  }) = _RankingState;
}
