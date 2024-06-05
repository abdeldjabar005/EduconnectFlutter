import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/features/profile/data/models/profile_model.dart';
import 'package:educonnect/features/profile/presentation/widgets/change_password.dart';
import 'package:educonnect/features/profile/presentation/widgets/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/core/widgets/custom_icon_button.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';

class ManageProfile extends StatelessWidget {
  ManageProfile({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  Map<String, String> roleTranslations = {
    'parent': 'والد',
    'teacher': 'معلم',
    'admin': 'مدير',
  };
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
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    ProfileModel profile = user.toProfileModel();

    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 15.h, top: 15.v),
        padding: EdgeInsets.symmetric(vertical: 54.v, horizontal: 15.h),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;
              ProfileModel profile = user.toProfileModel();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: '${EndPoints.storage}${user.profilePicture}',
                        height: 100.adaptSize,
                        width: 100.adaptSize,
                        radius: BorderRadius.circular(
                          50.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.h,
                          top: 28.v,
                          bottom: 28.v,
                          right: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ("${user.firstName} ${user.lastName}").length > 25
                                  ? '${("${user.firstName} ${user.lastName}").substring(0, 25)}...'
                                  : "${user.firstName} ${user.lastName}",
                              style: CustomTextStyles.titleLargeRobotoGray90001,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.v),
                            Text(
                              isRtl
                                  ? roleTranslations[user.role] ?? 'مستخدم'
                                  : (user.role == 'admin'
                                      ? 'School Admin'
                                      : user.role),
                              style: CustomTextStyles.titleGray,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.v),
                  InkWell(
                    borderRadius: BorderRadius.circular(29.h),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfile(
                          profile: profile,
                        ),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(29.h),
                      ),
                      width: 356 * MediaQuery.of(context).size.width / 414,
                      child: _buildFrame(
                        context,
                        profile: AppLocalizations.of(context)!
                            .translate("edit_profile")!,
                        icon: ImageConstant.imgFavorite,
                        fill: IconButtonStyleHelper.fillindigoA400,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.v),
                  InkWell(
                    borderRadius: BorderRadius.circular(29.h),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(29.h),
                      ),
                      width: 356 * MediaQuery.of(context).size.width / 414,
                      child: _buildFrame(
                        context,
                        profile: AppLocalizations.of(context)!
                            .translate("change_password")!,
                        icon: ImageConstant.imglockOrange,
                        fill: IconButtonStyleHelper.fillOrange,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.v),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
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
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
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
            right: 26.h,
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
          imagePath:
              isRtl ? ImageConstant.imgArrowLeft2 : ImageConstant.imgArrowRight,
          height: 20.v,
          width: 18.h,
          margin: EdgeInsets.only(
            left: 17.v,
            right: 17.v,
          ),
        ),
      ],
    );
  }
}
