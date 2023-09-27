import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../values/app_colors.dart';
import '../../values/text_styles.dart';
import '../button/primary_button.dart';

class PopupPrimary extends StatelessWidget {
  PopupPrimary({
    super.key,
    required this.title,
    required this.titleButton1,
    this.titleButton2 = 'Quay lại',
    this.onTap,
    this.textController,
    this.onTapCancel,
  });
  final String title;
  final String titleButton1;
  final String titleButton2;
  final void Function()? onTap;
  final void Function()? onTapCancel;
  final TextEditingController? textController;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.mediumMBlackS18,
      ),
      content: textController != null
          ? Form(
              key: _formKey,
              child: TextFormField(
                controller: textController,
                autofocus: true,
                onTapOutside: (e) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên để tiếp tục';
                  } else if (value.length > 40) {
                    return "Vui lòng nhập tên tối đa 40 ký tự! ";
                  }
                  return null;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                ],
                decoration: InputDecoration(
                  hintText: 'Phạm Văn A',
                  border: InputBorder.none,
                  hintStyle: TextStyles.regularMBlackS18,
                  fillColor: AppColors.colorFFFFFFFF,
                  contentPadding: const EdgeInsets.all(8.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.colorFF000000,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.colorFF000000,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.colorFF000000,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.colorFF000000,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.colorFF000000,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 1,
                style: TextStyles.regularMBlackS18,
                cursorColor: AppColors.colorFF000000,
              ),
            )
          : null,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Column(
          children: [
            PrimaryButton(
              onTap: ((textController == null) ||
                      (_formKey.currentState != null &&
                          textController != null &&
                          _formKey.currentState!.validate()))
                  ? onTap
                  : null,
              title: titleButton1,
              backgroundColor: AppColors.colorFF03456e,
              textColor: AppColors.colorFFFFFFFF,
              textSize: 16,
              borderColor: AppColors.colorFF03456e,
              textWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onTap: onTapCancel ?? () => Navigator.of(context).pop(),
              title: titleButton2,
              borderColor: AppColors.colorFF77dbe5,
              backgroundColor: AppColors.colorFFFFFFFF,
              textColor: AppColors.colorFF344054,
              textSize: 16,
              textWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
