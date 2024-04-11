import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/routes/app_routes.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/classrooms/presentation/widgets/join.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

class Classroom extends StatelessWidget {
  Classroom({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: AppColors.whiteA700,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Classroom",
            style: TextStyle(
              fontFamily: "Poppins",
              color: AppColors.black900,
              fontWeight: FontWeight.w400,
              fontSize: 18.v,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 25.v, horizontal: 15.h),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, "Join a School", "school"),
                      _buildDivider(context),
                      _buildButton(context, "Join a Class", "class"),
                    ],
                  ),
                  SizedBox(height: 33.v),
                  _buildDivider2(context, "Schools"),
                  SizedBox(height: 20.v),
                  Expanded(
                    child: BlocBuilder<ClassCubit, ClassState>(
                      builder: (context, state) {
                        final user = (context.watch<AuthCubit>().state
                                as AuthAuthenticated)
                            .user;
                        List<SchoolModel> schools = user.schools;

                        if (state is SchoolLoaded) {
                          schools = [...schools, state.school];
                        }

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: schools.length,
                          itemBuilder: (context, index) {
                            return _buildSchoolItem(context, schools[index]);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 33.v),
                  _buildDivider2(context, "Classes"),
                  SizedBox(height: 20.v),
                  Expanded(
                    child: BlocBuilder<ClassCubit, ClassState>(
                      builder: (context, state) {
                        final user = (context.watch<AuthCubit>().state
                                as AuthAuthenticated)
                            .user;
                        List<ClassModel> classes = user.classes;
                        if (state is ClassLoaded) {
                          classes = [...classes, state.classe];
                        }
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: classes.length,
                          itemBuilder: (context, index) {
                            return _buildClassItem(context, classes[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolItem(BuildContext context, SchoolModel school) {
    return InkWell(
      onTap: () {
        // Handle item click here
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.v),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
        height: 100.v,
        width: double.maxFinite,
        decoration: BoxDecoration(
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
                  '${school.membersCount} Members',
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
            const Icon(
              FontAwesomeIcons.arrowRight,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, ClassModel classe) {
    return InkWell(
      onTap: () {
        // Handle item click here
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.v),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
        height: 100.v,
        width: double.maxFinite,
        decoration: BoxDecoration(
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
                  "By ${classe.teacherFirstName} ${classe.teacherLastName}",
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
            const Icon(
              FontAwesomeIcons.arrowRight,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText, String type) {
    return CustomElevatedButton(
      height: 40.v,
      width: 127.h,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Join(type: type),
          ),
        );
      },
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.indigoA300),
      ),
      text: buttonText,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins12,
    );
  }

  Widget _buildDivider(BuildContext context) {
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
                  "Or ",
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
