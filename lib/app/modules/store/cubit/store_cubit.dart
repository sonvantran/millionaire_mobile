import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/store_box.dart';
import '../../../data/model/item_model.dart';
import '../../../data/model/user.dart';
import '../../../network/exceptions/bad_request_exception.dart';
import '../repository/store_repository.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit(this._repo) : super(const StoreState());

  final StoreRepository _repo;

  void init(User user) async {
    try {
      emit(state.copyWith(user: user));
      final li = StoreBox.getStore();
      SharedPreferences pre = await SharedPreferences.getInstance();
      final x = pre.getInt("isLastCallStore") ?? 0;
      if (li.isEmpty ||
          (DateTime.now().millisecondsSinceEpoch) - x >
              1000 * 60 * 60 * 24 * 5) {
        getStore();
        return;
      }
      final changedStore = await resolve(li[0].store);
      emit(state.copyWith(store: Store(store: changedStore)));
    } catch (e) {
      if (e is StateError) return;
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
      }
      SharedPreferences pre = await SharedPreferences.getInstance();
      await pre.setInt(
          "isLastCallStore", DateTime.now().millisecondsSinceEpoch);
      await StoreBox.deleteAll();
      li = await resolve(li);
      emit(state.copyWith(store: Store(store: handle(li))));
      StoreBox.setStore(Store(store: li));
    } catch (e) {
      if (e is StateError) return;
      rethrow;
    }
  }

  List<List<ItemModel>> handle(List<List<ItemModel>> li) {
    List<List<ItemModel>> list = List.from(li);
    for (var i in list) {
      _quickSort(i, 0, i.length - 1);
    }
    return list;
  }

  void _quickSort(List<ItemModel> arr, int left, int right) {
    if (left < right) {
      int partitionIndex = _partition(arr, left, right);
      _quickSort(arr, left, partitionIndex - 1);
      _quickSort(arr, partitionIndex + 1, right);
    }
  }

  int _partition(List<ItemModel> arr, int left, int right) {
    ItemModel pivot = arr[right];
    int i = left - 1;
    for (int j = left; j < right; j++) {
      if (int.parse(arr[j].price) <= int.parse(pivot.price)) {
        i++;
        ItemModel temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }
    ItemModel temp = arr[i + 1];
    arr[i + 1] = arr[right];
    arr[right] = temp;
    return i + 1;
  }

  bool callWhenError = false;
  void call() {
    if (callWhenError) return;
    callWhenError = true;
    getStore();
  }

  void selectAvatar(String image) async {
    emit(state.copyWith(message: null));
    if (state.user?.image == image) {
      emit(state.copyWith(message: 'Đã chọn rồi!'));
    } else {
      emit(state.copyWith(user: state.user?.copyWith(image: image)));
      final pre = await SharedPreferences.getInstance();
      pre.setString("imageUser", image);
      emit(state.copyWith(message: 'Chọn Avatar thành công!'));
    }
  }

  Future<void> buy(ItemModel item) async {
    if (state.store == null) return;
    SharedPreferences pre = await SharedPreferences.getInstance();
    List<String> preItems = pre.getStringList("boughtItem") ?? [];
    preItems.add('${item.name}-${item.price}');
    await pre.setStringList("boughtItem", preItems);
    final changedStore = await resolve(state.store!.store);
    emit(state.copyWith(store: Store(store: changedStore)));
    updateUser(int.parse(item.price));
    await StoreBox.deleteAll();
    StoreBox.setStore(Store(store: changedStore));
  }

  Future<List<List<ItemModel>>> resolve(List<List<ItemModel>> list) async {
    List<List<ItemModel>> li = List.from(list);
    SharedPreferences pre = await SharedPreferences.getInstance();
    List<String> preItems = pre.getStringList("boughtItem") ?? [];
    for (var i in li) {
      for (var item in i) {
        if (preItems.contains('${item.name}-${item.price}')) {
          item.isBuy = true;
        }
      }
    }
    return li;
  }

  void updateUser(int price) async {
    try {
      emit(state.copyWith(message: null));
      final userState = state.user;
      if (userState == null) return;
      final x = User(
        name: userState.name,
        point: userState.point - price,
        deviceId: userState.deviceId,
        playDate: Timestamp.now(),
      );
      emit(state.copyWith(user: x));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(message: e.message));
        return;
      }
      if (e is StateError) return;
      rethrow;
    }
  }
}
