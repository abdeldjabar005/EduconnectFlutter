import 'package:educonnect/features/auth/presentation/pages/login_screen.dart';
import 'package:educonnect/features/profile/presentation/pages/manage_profile.dart';
import 'package:educonnect/features/profile/presentation/widgets/bookmarks.dart';
import 'package:educonnect/features/profile/presentation/widgets/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/core/widgets/custom_icon_button.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/features/profile/presentation/widgets/add_school.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_children.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_classes.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_school.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_schools.dart';
import 'package:educonnect/features/splash/presentation/cubit/locale_cubit.dart';
import 'package:educonnect/injection_container.dart';

class MainProfile extends StatelessWidget {
  MainProfile({Key? key})
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

    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 15.h, top: 15.v),
        padding: EdgeInsets.symmetric(vertical: 54.v, horizontal: 15.h),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomImageView(
                        // imagePath:
                        // ImageConstant.imgRectangle17100x100, // TODO:user.image
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
                  SizedBox(height: 44.v),
                  InkWell(
                    borderRadius: BorderRadius.circular(29.h),
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) {
                          return ManageProfile();
                          // return ManageProfile();
                        },
                      ));
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(29.h),
                      ),
                      width: 356 * MediaQuery.of(context).size.width / 414,
                      child: _buildFrame(
                        context,
                        profile: AppLocalizations.of(context)!
                            .translate("manage_profile")!,
                        icon: ImageConstant.imgFavorite,
                        fill: IconButtonStyleHelper.fillindigoA400,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.v),
                  BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(29.h),
                        onTap: () {
                          navigatorKey.currentState!
                              .push(MaterialPageRoute(builder: (context) {
                            if (user.role == 'parent') {
                              return const ManageChildren();
                            } else if (user.role == 'teacher') {
                              // return ManageClass();
                              return const ManageClasses();
                            } else if (user.role == 'admin') {
                              // return ManageSchools();
                              if (user.school == null &&
                                      state is! SchoolLoaded ||
                                  state is SchoolRemoved) {
                                return const AddSchool();

                                // return AddSchool();
                              } else {
                                return ManageSchool();
                              }
                              // return ManageSchool();
                            } else {
                              return DefaultWidget();
                            }
                          }));
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: AppColors.whiteA700,
                            borderRadius: BorderRadius.circular(29.h),
                          ),
                          width: 356 * MediaQuery.of(context).size.width / 414,
                          child: _buildFrame(
                            context,
                            profile: user.role == 'parent'
                                ? AppLocalizations.of(context)!
                                    .translate("manage_children")!
                                : user.role == 'teacher'
                                    ? AppLocalizations.of(context)!
                                        .translate("manage_classes")!
                                    : user.role == 'admin'
                                        ? AppLocalizations.of(context)!
                                            .translate("manage_school")!
                                        : AppLocalizations.of(context)!
                                            .translate("default")!,
                            icon: user.role == 'parent'
                                ? ImageConstant.imgClose
                                : user.role == 'teacher'
                                    ? ImageConstant.cap
                                    : user.role == 'admin'
                                        ? ImageConstant.school
                                        : ImageConstant.imgClose,
                            fill: IconButtonStyleHelper.fillLightGreen,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 28.v),
                  InkWell(
                    borderRadius: BorderRadius.circular(29.h),
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) {
                          return BookMarks();
                          // return ManageProfile();
                        },
                      ));
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(29.h),
                      ),
                      width: 356 * MediaQuery.of(context).size.width / 414,
                      child: _buildFrame(
                        context,
                        profile: AppLocalizations.of(context)!
                            .translate("bookmarks")!,
                        icon: ImageConstant.imgBookmarkOrange300,
                        fill: IconButtonStyleHelper.fillOrange,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.v),
                  InkWell(
                    borderRadius: BorderRadius.circular(29.h),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text(AppLocalizations.of(context)!
                                        .translate("english")!),
                                    onTap: () {
                                      BlocProvider.of<LocaleCubit>(context,
                                              listen: false)
                                          .toEnglish();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text(AppLocalizations.of(context)!
                                        .translate("arabic")!),
                                    onTap: () {
                                      BlocProvider.of<LocaleCubit>(context,
                                              listen: false)
                                          .toArabic();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text(AppLocalizations.of(context)!
                                        .translate("french")!),
                                    onTap: () {
                                      BlocProvider.of<LocaleCubit>(context,
                                              listen: false)
                                          .toEnglish();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(29.h),
                      ),
                      width: 356 * MediaQuery.of(context).size.width / 414,
                      child: _buildFrame(
                        context,
                        profile: AppLocalizations.of(context)!
                            .translate("change_language")!,
                        icon: ImageConstant.imgSearchLightGreen400,
                        fill: IconButtonStyleHelper.fillGreenA,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.v),
                  InkWell(
                    borderRadius: BorderRadius.circular(29.h),
                    onTap: () async {
                      await context.read<AuthCubit>().logout();
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
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
                        icon: ImageConstant.imgBoldDuotoneEssentional,
                        fill: IconButtonStyleHelper.fillRed,
                        profile:
                            AppLocalizations.of(context)!.translate("logout")!,
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
