import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_ads/banner_anchor_ad_widget.dart';

import '../../../core/values/text_styles.dart';
import '../../../core/widgets/appBar/custom_appbar.dart';
import '../cubit/store_cubit.dart';
import '../cubit/store_state.dart';
import '../repository/store_repository.dart';
import '../widgets/category.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreCubit(context.read<StoreRepository>())..init(),
      child: _buildPage(context),
    );
  }

  List<String> labels = [
    "Tầng lớp trung lưu",
    "Đẳng Cấp Thượng Lưu",
    "Thượng Lưu Đích Thực",
    "Thượng Đẳng Tài Phiệt",
    "Thế Hệ Triệu Phú",
    "Tỷ phú",
  ];
  Widget _buildPage(BuildContext context) {
    return BlocBuilder<StoreCubit, StoreState>(builder: (context, state) {
      final store = state.store?.store ?? [];
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              CustomAppBar(
                top: 32.h,
                leading: CustomAppbarItem(
                  icon: Icons.arrow_back_outlined,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: 'Cửa hàng',
              ),
              Expanded(
                child: store.isNotEmpty
                    ? ListView.builder(
                        itemCount: store.length,
                        itemBuilder: (context, index) =>
                            Category(label: labels[index], items: store[index]),
                      )
                    : Center(
                        child: Text(
                          "Chưa có sản phẩm nào",
                          style: TextStyles.regularWhiteS20,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              const SkyBannerAnchorAdWidget()
            ],
          ),
        ),
      );
    });
  }
}
