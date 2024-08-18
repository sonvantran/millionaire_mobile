import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'text_styles.dart';

import 'app_colors.dart';

class ShowMessageInternal {
  static void showOverlay(BuildContext context, String message) async {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.115,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(64)),
              color: AppColors.colorFFFFFFFF,
              border: Border.all(color: AppColors.colorFF03456e),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Text(
              message,
              style: TextStyles.mediumMBlackS18,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  static void showMessage(String message) async {
    await Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColors.colorFFFFFFFF.withOpacity(0.8),
      textColor: AppColors.colorFF000000,
      fontSize: 14,
    );
  }
}
