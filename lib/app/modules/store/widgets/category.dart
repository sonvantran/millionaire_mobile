import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/model/item_model.dart';
import '../cubit/store_cubit.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
    required this.label,
    required this.items,
  });

  final String label;
  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
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
              label,
              style: TextStyles.boldWhiteS24,
            ),
          ),
          SizedBox(
            height: 160.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  width: 110.w,
                  padding: EdgeInsets.all(8.r),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    color: AppColors.colorFFF5F5F5,
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
                              color: AppColors.colorFF344054.withOpacity(0.5),
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
                          Positioned.fill(
                            child: Transform.rotate(
                              angle: -0.8,
                              child: Text(
                                item.price,
                                style: const TextStyle(fontSize: 20),
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
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
