import 'package:flutter_bloc/flutter_bloc.dart';

import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(const StoreState());
}