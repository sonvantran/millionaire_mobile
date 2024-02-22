import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/model/item_model.dart';
import 'category.dart';

class ItemPopup extends StatefulWidget {
  const ItemPopup({
    super.key,
    required this.model,
    required this.canBuy,
    this.onError,
    this.onBuy,
  });
  final ItemModel model;
  final bool canBuy;
  final VoidCallback? onError;
  final VoidCallback? onBuy;

  @override
  State<ItemPopup> createState() => _ItemPopupState();
}

class _ItemPopupState extends State<ItemPopup> {
  bool isMua = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      shadowColor: AppColors.colorFF000000,
      backgroundColor: AppColors.colorFF375193,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_sharp,
                    color: AppColors.colorFFFFFFFF,
                  ),
                  iconSize: 44.r,
                ),
              ),
              Text(
                widget.model.name,
                style: TextStyles.boldWhiteS20,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.4,
                  imageUrl: widget.model.image,
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: AppColors.colorFF57B9FB,
                    size: 32.sp,
                  ),
                  errorWidget: (context, url, error) {
                    widget.onError?.call();
                    return const Icon(Icons.error);
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "${formatCurrency(widget.model.price)} đ",
                style: TextStyles.boldWhiteS20,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              widget.model.isBuy || !widget.canBuy || isMua
                  ? Text(
                      isMua || widget.model.isBuy || widget.canBuy
                          ? "Đã mua".toUpperCase()
                          : "Không đủ \$".toUpperCase(),
                      style: TextStyles.boldBlackS20.copyWith(
                          color: !widget.canBuy
                              ? AppColors.colorFF940000.withOpacity(0.5)
                              : AppColors.colorFF72F672.withOpacity(0.5)),
                    )
                  : InkWell(
                      onTap: widget.model.isBuy || !widget.canBuy
                          ? null
                          : () {
                              widget.onBuy?.call();
                              setState(() {
                                isMua = true;
                              });
                            },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.colorFF77dbe5, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                          color: AppColors.colorFF03456e,
                        ),
                        width: 200.w,
                        height: 50.h,
                        child: Text(
                          "Mua",
                          style: TextStyles.mediumMWhiteS18,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
