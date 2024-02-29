import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sky_ads/native_ad_widget.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/model/item_model.dart';
import '../../../data/model/user.dart';
import '../cubit/store_cubit.dart';
import 'item_popup.dart';

class Category extends StatefulWidget {
  const Category(
      {super.key,
      required this.label,
      required this.items,
      required this.user});
  final String label;
  final List<ItemModel> items;
  final User user;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isLoadFail = false;
  @override
  Widget build(BuildContext context) {
    final randomIndex = Random().nextInt(widget.items.length);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: const BoxDecoration(
              color: AppColors.colorFF0B2D42,
            ),
            child: Text(
              widget.label,
              style: TextStyles.boldWhiteS24,
            ),
          ),
          SizedBox(
            height: 160.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final text = "${formatCurrency(item.price)} đ";
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => showBuyPopup(
                        context,
                        item,
                        widget.user.point >= int.parse(item.price),
                        onError: () => context.read<StoreCubit>().call(),
                        onBuy: () => context.read<StoreCubit>().buy(item),
                      ),
                      child: Container(
                        width: 110.w,
                        padding: EdgeInsets.all(8.r),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          color: item.isBuy
                              ? AppColors.colorFF72F672
                              : AppColors.colorFFF5F5F5,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                  child: CachedNetworkImage(
                                    color: AppColors.colorFF344054
                                        .withOpacity(0.5),
                                    colorBlendMode: BlendMode.darken,
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                    imageUrl: item.image,
                                    placeholder: (context, url) =>
                                        SpinKitFadingCircle(
                                      color: AppColors.colorFF57B9FB,
                                      size: 32.sp,
                                    ),
                                    errorWidget: (context, url, error) {
                                      context.read<StoreCubit>().call();
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                ),
                                item.isBuy
                                    ? const SizedBox.shrink()
                                    : Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Transform.rotate(
                                            angle: -0.6,
                                            child: Text(
                                              text,
                                              style: TextStyles.score.copyWith(
                                                  fontSize:
                                                      (25 - text.length).sp),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                            Text(
                              item.name,
                              style: TextStyles.boldBlackS10,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index == randomIndex)
                      !isLoadFail
                          ? Container(
                              width: 200.w,
                              height: 160.h,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: SkyNativeAdWidget(
                                onAdFailedToLoad: () => setState(() {
                                  isLoadFail = true;
                                }),
                              ),
                            )
                          : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

void showBuyPopup(
  BuildContext context,
  ItemModel model,
  bool canBuy, {
  VoidCallback? onError,
  VoidCallback? onBuy,
}) {
  showDialog(
    context: context,
    builder: (context) => ItemPopup(
      canBuy: canBuy,
      model: model,
      onBuy: onBuy,
      onError: onError,
    ),
  );
}

String formatCurrency(String twfAmount) {
  int amount = int.tryParse(twfAmount.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

  String formattedAmount = amount.toStringAsFixed(0);

  formattedAmount = formattedAmount.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');

  return formattedAmount;
}
