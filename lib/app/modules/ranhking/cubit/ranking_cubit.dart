import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/user.dart';
import '../repository/ranking_repository.dart';
import 'ranking_state.dart';

class RankingCubit extends Cubit<RankingState> {
  RankingCubit(this._rankingRepository) : super(const RankingState());

  final RankingRepository _rankingRepository;

  void optimize() {
    try {
      final x = Random().nextInt(50);
      if (x != 10) return;
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
      optimize();
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

  void init(User user) async {
    await updateLast(user);
    getUsers(false);
  }

  Future<void> updateLast(User user) async {
    final pre = await SharedPreferences.getInstance();
    final x = pre.getInt("lastPoint");
    final y = pre.getString("lastName");
    if (x != user.point || y != user.name) {
      await _rankingRepository.updateUser(user: user);
    }
  }
}
