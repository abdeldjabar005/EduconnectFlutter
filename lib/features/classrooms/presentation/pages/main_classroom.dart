import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/routes/app_routes.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/classrooms/presentation/pages/classroom.dart';
import 'package:quotes/features/classrooms/presentation/widgets/join.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

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
                  if (user.schools.isEmpty && user.schools.isEmpty) {
                    return _buildClassroomPage(context);
                  } else {
                    return Classroom();
                  }
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
                "You are not part of any school or class yet",
                style: CustomTextStyles.titleLargePoppinsff2a2a2a.copyWith(
                  color: AppColors.black900,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 44.v),
            _buildFrame(context,
                text:
                    "if you have a school code click the button bellow to join the school now",
                image: ImageConstant.imgSchool,
                buttonText: "Join a School", onPressed: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return Join(
                    type: 'school',
                  );
                },
              ));
            }),
            SizedBox(height: 20.v),
            _buildDivider(context),
            SizedBox(height: 20.v),
            _buildFrame(context,
                text:
                    "if you have a class code click the button bellow to join the class now",
                image: ImageConstant.imgClass,
                buttonText: "Join a Class", onPressed: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) {
                  return Join(
                    type: 'class',
                  );
                },
              ));
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
      width: 127.h,
      onPressed: onPressed,
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
        padding: EdgeInsets.only(left: 35.h, right: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 117.h,
                child: const Divider(),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 3.v),
                child: Text(
                  "Or ",
                  style: CustomTextStyles.titleLargePoppinsff2a2a2a.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 117.h,
                child: const Divider(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
