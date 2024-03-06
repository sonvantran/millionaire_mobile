import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sky_ads/native_ad_widget.dart';
import 'package:sky_ads/sky_ads.dart';

import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/services/ads_manager.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/show_message_internal.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widgets/appBar/custom_appbar.dart';
import '../../../data/model/user.dart';
import '../../login/cubit/login_cubit.dart';
import '../../login/widgets/score_user.dart';
import '../cubit/store_cubit.dart';
import '../cubit/store_state.dart';
import '../repository/store_repository.dart';
import '../widgets/category.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key, required this.user, required this.cubit});

  final User user;
  final LoginCubit cubit;

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> with RouteAwareAnalytics {
  @override
  TrackingScreenViewType get route => TrackingScreenViewType.store;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StoreCubit(context.read<StoreRepository>())..init(widget.user),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreCubit, StoreState>(
          listenWhen: (previous, current) => previous.user != current.user,
          listener: (context, state) {
            if (state.user != null) {
              widget.cubit.setUser(state.user!);
            }
          },
        ),
        BlocListener<StoreCubit, StoreState>(
          listenWhen: (previous, current) =>
              previous.message != current.message,
          listener: (context, state) {
            if (state.message != null) {
              ShowMessageInternal.showOverlay(context, state.message!);
            }
          },
        ),
      ],
      child: BlocBuilder<StoreCubit, StoreState>(builder: (context, state) {
        final store = state.store?.store;
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
                const SizedBox(height: 4),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 12.w),
                  child: ScoreUser(text: state.user?.point ?? 0),
                ),
                const SizedBox(height: 8),
                store == null
                    ? Expanded(
                        child: Center(
                          child: SpinKitCircle(
                            color: AppColors.colorFF77dbe5,
                            size: 100.r,
                          ),
                        ),
                      )
                    : Expanded(
                        child: store.isNotEmpty
                            ? ListView.builder(
                                itemCount: store.length,
                                itemBuilder: (context, index) => Category(
                                  label: labels[index],
                                  items: store[index],
                                  user: state.user ?? widget.user,
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Chưa có sản phẩm nào",
                                  style: TextStyles.regularWhiteS20,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                const SkyNativeAdWidget(
                  placement: AdsId.nativeStoreBottom,
                  size: NativeAdSize.small,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
