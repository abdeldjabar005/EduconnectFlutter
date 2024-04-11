import 'package:flutter/material.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/widgets/base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
    this.isLoading = false,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: this.height ?? 56.v,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: isLoading
              ? SizedBox(
                  height: 24.v,
                  width: 24.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.whiteA700,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leftIcon ?? const SizedBox.shrink(),
                    Text(
                      text,
                      style: buttonTextStyle ?? theme.textTheme.titleMedium,
                    ),
                    rightIcon ?? const SizedBox.shrink(),
                  ],
                ),
        ),
      );
}
