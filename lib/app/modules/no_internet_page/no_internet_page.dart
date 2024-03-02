import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/values/app_colors.dart';
import '../../core/values/text_styles.dart';
import '../../core/widgets/button/primary_button.dart';

const platform = MethodChannel('congthiep');

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  void initConnectionListen() {
    if (!mounted) return;
    Connectivity().onConnectivityChanged.listen((result) {
      if(!mounted) return;
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        if (!context.mounted) return;
        context.router.popUntilRoot();
      }
    });
  }

  @override
  void initState() {
    initConnectionListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorFFFFFFFF,
      body: PopScope(
        canPop: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/icons/ic_no_internet.svg"),
                  SizedBox(height: 36.h),
                  Text(
                    "Không Có Internet",
                    style: TextStyles.mediumMBlueS16
                        .copyWith(color: AppColors.colorFF000000),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Vui lòng kiểm tra kết nối của bạn!",
                    style: TextStyles.mediumBlackS14
                        .copyWith(color: AppColors.colorFF606060),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: SizedBox(
                  width: 218.w,
                  height: 59.h,
                  child: PrimaryButton(
                    textSize: 20.r,
                    textWeight: FontW.mediumM,
                    onTap: () => platform.invokeMethod("openWifiSetting"),
                    title: "Thử lại",
                    backgroundColor: AppColors.colorFFF1B620,
                    textColor: AppColors.colorFF000000,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
