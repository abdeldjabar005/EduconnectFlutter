import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/pages/class_details.dart';
import 'package:educonnect/features/classrooms/presentation/pages/school_details.dart';
import 'package:educonnect/features/classrooms/presentation/widgets/join.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/injection_container.dart';

class MainClassroom extends StatelessWidget {
  MainClassroom({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

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
                  return BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      log(user.schools.toString());
                      if (user.schools.isNotEmpty || user.classes.isNotEmpty) {
                        log('User has schools or classes');
                        return _buildClassroom(context);

                        // WidgetsBinding.instance!.addPostFrameCallback((_) {
                        //   navigatorKey.currentState!.pushReplacement(
                        //     MaterialPageRoute(
                        //       builder: (context) {
                        //         return _buildClassroom(context);
                        //       },
                        //     ),
                        //   );
                        // });
                      } else {
                        log('User has no schools or classes');
                        return _buildClassroomPage(context);

                        // WidgetsBinding.instance!.addPostFrameCallback((_) {
                        //   navigatorKey.currentState!.pushReplacement(
                        //     MaterialPageRoute(
                        //       builder: (context) {
                        //         return _buildClassroomPage(context);
                        //       },
                        //     ),
                        //   );
                        // });
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildClassroomPage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 54.v, horizontal: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!.translate("no_class_school")!,
                style: CustomTextStyles.titleLargePoppinsff2a2a2a.copyWith(
                  color: AppColors.black900,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 44.v),
            _buildFrame(context,
                text:
                    AppLocalizations.of(context)!.translate("have_code_join")!,
                image: ImageConstant.imgSchool,
                buttonText: AppLocalizations.of(context)!
                    .translate("join_school")!, onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Join(type: 'school'),
                ),
              );
            }),
            SizedBox(height: 20.v),
            _buildDivider(context),
            SizedBox(height: 20.v),
            _buildFrame(context,
                text: AppLocalizations.of(context)!
                    .translate("have_code_join_class")!,
                image: ImageConstant.imgClass,
                buttonText: AppLocalizations.of(context)!
                    .translate("join_class")!, onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Join(type: 'class'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildFrame(
    BuildContext context, {
    required String text,
    required String image,
    required String buttonText,
    required Function() onPressed,
  }) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10.v, horizontal: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
      height: 250.v,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
            BorderSide(color: Colors.black.withOpacity(0.1))),
        color: AppColors.whiteA700,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.h),
                width: 140.h,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.h,
                    top: 16.v,
                    bottom: 20.v,
                  ),
                  child: Text(
                    text,
                    style: CustomTextStyles.titleMediumPoppinsblacksmall,
                  ),
                ),
              ),
              _buildButton(context, onPressed, buttonText),
            ],
          ),
          CustomImageView(
            // imagePath: ImageConstant.imgArrowRight,
            imagePath: image,
            height: 200.v,
            width: 220.h,
            margin: EdgeInsets.only(
              // left: 12.v,
              bottom: 15.v,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, Function() onPressed, String buttonText) {
    return CustomElevatedButton(
      height: 40.v,
      width: 135.h,
      onPressed: onPressed,
      buttonStyle: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.indigoA300),
      ),
      text: buttonText,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins10,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 35.h, right: 35.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 113.h,
                child: const Divider(),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 3.v),
                child: Text(
                  AppLocalizations.of(context)!.translate("or")!,
                  style: CustomTextStyles.titleLargePoppinsff2a2a2a.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 113.h,
                child: const Divider(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildClassroom(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: AppColors.whiteA700,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate("classroom")!,
            style: TextStyle(
              fontFamily: "Poppins",
              color: AppColors.black900,
              fontWeight: FontWeight.w400,
              fontSize: 18.v,
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 25.v, horizontal: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton2(
                          context,
                          AppLocalizations.of(context)!
                              .translate("join_school")!,
                          "school"),
                      _buildDivider3(context),
                      _buildButton2(
                          context,
                          AppLocalizations.of(context)!
                              .translate("join_class")!,
                          "class"),
                    ],
                  ),
                  SizedBox(height: 33.v),
                  _buildDivider2(context,
                      AppLocalizations.of(context)!.translate("schools")!),
                  SizedBox(height: 20.v),
                  BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      final authState = context.watch<AuthCubit>().state;
                      if (authState is AuthAuthenticated) {
                        final user = authState.user;
                        List<SchoolModel> schools = user.schools;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: schools.length,
                          itemBuilder: (context, index) {
                            return _buildSchoolItem(context, schools[index]);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 33.v),
                  _buildDivider2(context,
                      AppLocalizations.of(context)!.translate("classes")!),
                  SizedBox(height: 20.v),
                  BlocBuilder<ClassCubit, ClassState>(
                      builder: (context, state) {
                    final authState = context.watch<AuthCubit>().state;
                    if (authState is AuthAuthenticated) {
                      final user = authState.user;
                      List<ClassModel> classes = user.classes;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: classes.length,
                        itemBuilder: (context, index) {
                          return _buildClassItem(context, classes[index]);
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolItem(BuildContext context, SchoolModel school) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SchoolDetails(school: school),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.v),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
        height: 100.v,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
              BorderSide(color: Colors.black.withOpacity(0.1))),
          color: AppColors.whiteA700,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(
              imagePath: '${EndPoints.storage}${school.image}',
              radius: BorderRadius.circular(30),
              height: 114.v,
              width: 114.h,
              // margin: EdgeInsets.all(5.v),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: CustomTextStyles.titleMediumPoppinsblacksmall.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${school.membersCount} ${AppLocalizations.of(context)!.translate("members")!}',
                  style:
                      CustomTextStyles.titleMediumPoppinsblacksmall2.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.h,
            ),
            SizedBox(
              width: 10.v,
            ),
            Icon(
              isRtl ? FontAwesomeIcons.arrowLeft : FontAwesomeIcons.arrowRight,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, ClassModel classe) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClassDetails(classe: classe),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.v),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
        height: 100.v,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
              BorderSide(color: Colors.black.withOpacity(0.1))),
          color: AppColors.whiteA700,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(
              imagePath: '${EndPoints.storage}${classe.image}',
              radius: BorderRadius.circular(30),

              height: 114.v,
              width: 114.h,
              // margin: EdgeInsets.all(5.v),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classe.name,
                  style: CustomTextStyles.titleMediumPoppinsblacksmall.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${AppLocalizations.of(context)!.translate("by")!} ${classe.teacherFirstName} ${classe.teacherLastName}",
                  style:
                      CustomTextStyles.titleMediumPoppinsblacksmall2.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.h,
            ),
            SizedBox(
              width: 10.v,
            ),
            Icon(
              isRtl ? FontAwesomeIcons.arrowLeft : FontAwesomeIcons.arrowRight,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton2(BuildContext context, String buttonText, String type) {
    return CustomElevatedButton(
      height: 40.v,
      width: 135.h,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Join(type: type),
          ),
        );
      },
      buttonStyle: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.indigoA300),
      ),
      text: buttonText,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins10,
    );
  }

  Widget _buildDivider3(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 5.h, right: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 25.h,
                child: const Divider(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
                child: Text(
                  AppLocalizations.of(context)!.translate("or")!,
                  style: CustomTextStyles.titleMediumPoppinsblacksmall.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 25.h,
                child: const Divider(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider2(BuildContext context, type) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
            child: SizedBox(
              width: 100.h,
              child: const Divider(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 5.v),
              child: Text(
                type,
                style: CustomTextStyles.titleMediumPoppinsblacksmall.copyWith(
                  color: AppColors.black900,
                  fontWeight: FontWeight.w500,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
            child: SizedBox(
              width: 100.h,
              child: const Divider(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
