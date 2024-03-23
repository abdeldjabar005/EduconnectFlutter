import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/core/widgets/custom_icon_button.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

class MainProfile extends StatelessWidget {
  MainProfile({Key? key})
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
                  return _buildProfileHome(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHome(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 54.v, horizontal: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRectangle17100x100,
                height: 100.adaptSize,
                width: 100.adaptSize,
                radius: BorderRadius.circular(
                  50.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25.h,
                  top: 28.v,
                  bottom: 28.v,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: CustomTextStyles.titleLargeRobotoGray90001,
                    ),
                    SizedBox(height: 2.v),
                    Text(
                      user.role,
                      style: CustomTextStyles.titleGray,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 44.v),
          InkWell(
            borderRadius: BorderRadius.circular(29.h),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return DefaultWidget();
                  // return ManageProfile();
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 7.h,
              ),
              width: 326,
              child: _buildFrame(
                context,
                profile: "Manage Profile",
                icon: ImageConstant.imgFavorite,
                fill: IconButtonStyleHelper.fillindigoA400,
              ),
            ),
          ),
          SizedBox(height: 28.v),
          InkWell(
            borderRadius: BorderRadius.circular(29.h),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return DefaultWidget();
                  // return ManageProfile();
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 7.h,
              ),
              width: 326,
              child: _buildFrame(
                context,
                profile: "Manage Children",
                icon: ImageConstant.imgClose,
                fill: IconButtonStyleHelper.fillLightGreen,
              ),
            ),
          ),
          SizedBox(height: 28.v),
          InkWell(
            borderRadius: BorderRadius.circular(29.h),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return DefaultWidget();
                  // return ManageProfile();
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 7.h,
              ),
              width: 326,
              child: _buildFrame(
                context,
                profile: "Bookmarks",
                icon: ImageConstant.imgBookmarkOrange300,
                fill: IconButtonStyleHelper.fillOrange,
              ),
            ),
          ),
          SizedBox(height: 28.v),
          InkWell(
            borderRadius: BorderRadius.circular(29.h),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return DefaultWidget();
                  // return ManageProfile();
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 7.h,
              ),
              width: 326,
              child: _buildFrame(
                context,
                icon: ImageConstant.imgBoldDuotoneEssentional,
                fill: IconButtonStyleHelper.fillRed,
                profile: "Help",
              ),
            ),
          ),
          SizedBox(height: 28.v),
          InkWell(
            borderRadius: BorderRadius.circular(29.h),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return DefaultWidget();
                  // return ManageProfile();
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 7.h,
              ),
              width: 326,
              child: _buildFrame(
                context,
                profile: "Settings",
                icon: ImageConstant.imgSearchLightGreen400,
                fill: IconButtonStyleHelper.fillGreenA,
              ),
            ),
          ),
          SizedBox(height: 5.v),
        ],
      ),
    );
  }

  /// Common widget
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
