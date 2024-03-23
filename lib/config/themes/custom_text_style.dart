import 'package:flutter/material.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyMediumRobotoGray700 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: postTheme.gray700,
        fontSize: 13.fSize,
      );
  static get bodyMediumRobotoGray900 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: postTheme.gray900,
        fontSize: 13.fSize,
      );
  static get bodyMediumRobotoGray2 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: AppColors.gray2,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w400,
      );
  static get bodyMediumRobotoGray90001 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: postTheme.gray90001,
        fontSize: 13.fSize,
      );
  static get titleMediumPoppinsGray300 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: AppColors.gray300,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsGray900 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: postTheme.gray90001,
        fontSize: 16.v,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsblack =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: postTheme.black900,
        fontSize: 16.v,
        fontWeight: FontWeight.w800,
      );
  static get bodyMediumRobotoGray90002 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: postTheme.gray90002,
        fontSize: 13.fSize,
      );
  static get titleMediumPoppins =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: postTheme.whiteA700,
        fontSize: 16.v,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsgray600 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: AppColors.gray600,
        fontSize: 16.v,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsBlack =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: Color(0XFF000000),
        fontSize: 30.fSize,
        fontWeight: FontWeight.w800,
      );
  static get titleMediumPoppinsBlack2 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: Color(0XFF000000),
        fontSize: 24.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleLargePoppinsff2a2a2a =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: Color(0XFF2A2A2A),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsBluegray100 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: AppColors.red400,
        fontSize: 15.v,
        fontWeight: FontWeight.w200,
      );
  static get titleMediumPoppinsff648ddb =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: Color(0XFF648DDB),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsPrimary =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.v,
        fontWeight: FontWeight.w300,
      );
  static get titleMediumPoppinsff989898 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: Color(0XFF989898),
        fontWeight: FontWeight.w600,
      );
  // Title text style
  static get titleLargeRobotoGray90001 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: postTheme.gray90001,
        fontWeight: FontWeight.w600,
      );
  static get titleGray => theme.textTheme.titleLarge!.roboto.copyWith(
        color: postTheme.gray300,
        fontWeight: FontWeight.w400,
      );
  static get titleMediumPoppinsErrorContainer =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.errorContainer,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumPoppinsGray40001 =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: AppColors.gray40001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumBlueA200 => theme.textTheme.titleMedium!.copyWith(
        color: postTheme.blueA200,
      );
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: postTheme.black900,
      );
  static get titleSmallGray90001 => theme.textTheme.titleSmall!.copyWith(
        color: postTheme.gray90001,
      );
  static get displayMedium45 => theme.textTheme.displayMedium!.copyWith(
        fontSize: 44.fSize,
        fontWeight: FontWeight.w800,
        fontFamily: 'Poppins',
        color: AppColors.indigoA400,
      );

  static get titleMediumPoppinsff2a2a2a =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: Color(0XFF2A2A2A),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff2a2a2a => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF2A2A2A),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff545454 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF545454),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff648ddb => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF648DDB),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff989898 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF989898),
        fontWeight: FontWeight.w600,
      );
}

extension on TextStyle {
  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get rubik {
    return copyWith(
      fontFamily: 'Rubik',
    );
  }
}
