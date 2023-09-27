import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extension/integer_extension.dart';
import '../repository/ranking_repository.dart';
import 'ranking_state.dart';

class RankingCubit extends Cubit<RankingState> {
  RankingCubit(this._rankingRepository) : super(const RankingState());

  final RankingRepository _rankingRepository;

  void getQuestions(String type) async {
    try {
      if ((type == 'day' && state.usersday != null) ||
          (type == 'month' && state.usersMonth != null) ||
          (type == 'year' && state.usersYear != null)) return;
      final users = await _rankingRepository.getRank(type);
      if (type == 'day') {
        emit(state.copyWith(usersday: users));
      } else if (type == 'month') {
        emit(state.copyWith(usersMonth: users));
      } else {
        emit(state.copyWith(usersYear: users));
      }
    } catch (e) {
      if (e is StateError) return;
      rethrow;
    }
  }

  void setFilter(int filter) {
    emit(state.copyWith(filter: filter));
    String type = filter.intToTimeType();
    getQuestions(type);
  }

  void init() {
    getQuestions('day');
  }
}
