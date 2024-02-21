import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/store_box.dart';
import '../../../data/model/item_model.dart';
import '../repository/store_repository.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit(this._repo) : super(const StoreState());

  final StoreRepository _repo;

  void init() {
    try {
      final li = StoreBox.getStore();
      if (li.isEmpty) {
        getStore();
        return;
      }
      emit(state.copyWith(store: li[0]));
    } catch (e) {
      rethrow;
    }
  }

  void getStore() async {
    try {
      final re = await _repo.getStore();
      List<List<ItemModel>> li = [];
      for (final i in re) {
        if (i.doc.data() != null) {
          List<ItemModel> j = ItemModel.fromMap(i.doc.data()!);
          li.add(j);
        }
        log(i.doc.data().toString());
      }
      await StoreBox.deleteAll();
      emit(state.copyWith(store: Store(store: li)));
      StoreBox.setStore(Store(store: li));
    } catch (e) {
      rethrow;
    }
  }

  bool callWhenError = false;
  void call() {
    if (callWhenError) return;
    callWhenError = true;
    getStore();
  }
}
