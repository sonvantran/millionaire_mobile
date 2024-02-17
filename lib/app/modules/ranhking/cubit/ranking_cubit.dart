import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/ranking_repository.dart';
import 'ranking_state.dart';

class RankingCubit extends Cubit<RankingState> {
  RankingCubit(this._rankingRepository) : super(const RankingState());

  final RankingRepository _rankingRepository;

  void optimize() {
    try {
      _rankingRepository.optimize();
    } catch (e) {
      rethrow;
    }
  }

  void getUsers(bool filter) async {
    try {
      if ((!filter && state.usersday != null) ||
          (filter && state.allUser != null)) return;

      if (filter) {
        final users = await _rankingRepository.getAllRank();
        emit(state.copyWith(allUser: users));
      } else {
        final users = await _rankingRepository.getRank();
        emit(state.copyWith(usersday: users));
      }
    } catch (e) {
      if (e is StateError) return;
      if (e is FirebaseException) {
        emit(state.copyWith(message: "Hệ thống đang gặp lỗi"));
        return;
      }
      rethrow;
    }
  }

  void setFilter(bool filter) {
    emit(state.copyWith(filter: filter));
    getUsers(filter);
  }

  void init() {
    getUsers(false);
  }
}
