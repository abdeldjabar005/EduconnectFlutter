import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_icon_button.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/splash/presentation/cubit/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (navigatorKey.currentState!.canPop()) {
            navigatorKey.currentState!.pop();
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildSettingsHome(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsHome(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 15.h, top: 15.v),
        padding: EdgeInsets.symmetric(vertical: 54.v, horizontal: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(29.h),
              onTap: () {
                if (AppLocalizations.of(context)!.isEnLocale) {
                  BlocProvider.of<LocaleCubit>(context).toArabic();
                } else {
                  BlocProvider.of<LocaleCubit>(context).toEnglish();
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.whiteA700,
                  borderRadius: BorderRadius.circular(29.h),
                ),
                width: 356 * MediaQuery.of(context).size.width / 414,
                child: _buildFrame(
                  context,
                  profile: AppLocalizations.of(context)!.translate("change_language")!,
                  icon: ImageConstant.imgUser,
                  fill: IconButtonStyleHelper.fillRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrame(
    BuildContext context, {
    required String profile,
    required String icon,
    required BoxDecoration fill,
  }) {
    return Row(
      children: [
        CustomIconButton(
          height: 59.v,
          width: 58.h,
          padding: EdgeInsets.all(10.h),
          decoration: fill,
          child: CustomImageView(
            height: 55.v,
            width: 53.h,
            imagePath: icon,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 26.h,
            top: 16.v,
            bottom: 12.v,
          ),
          child: Text(
            profile,
            style: theme.textTheme.titleLarge!.copyWith(
              color: AppColors.blueGray900,
            ),
          ),
        ),
        Spacer(),
        CustomImageView(
          imagePath: ImageConstant.imgArrowRight,
          height: 25.v,
          width: 23.h,
          margin: EdgeInsets.only(
            left: 17.v,
          ),
        ),
      ],
    );
  }
}
