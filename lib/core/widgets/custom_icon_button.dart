import 'package:flutter/material.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: AppColors.indigoA200.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(29.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillGreenA => BoxDecoration(
        color: AppColors.lightGreen400.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: AppColors.orange300.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      static BoxDecoration get gold => BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      
  static BoxDecoration get fillRed => BoxDecoration(
        color: AppColors.red400.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      static BoxDecoration get fillRed2 => BoxDecoration(
        color: AppColors.red500.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      
  static BoxDecoration get fillLightGreen => BoxDecoration(
        color: AppColors.lightGreen400.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      static BoxDecoration get fillLightGreen500 => BoxDecoration(
        color: AppColors.lightGreen500.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      
  static BoxDecoration get fillindigoA400 => BoxDecoration(
        color: AppColors.indigoA400.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      static BoxDecoration get blue => BoxDecoration(
        color: AppColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29.h),
      );
      
}
