import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/core/widgets/custom_icon_button.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/classrooms/presentation/pages/school_details.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/profile/presentation/widgets/update_school.dart';

class ManageSchool extends StatelessWidget {
  ManageSchool({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return BlocListener<ClassCubit, ClassState>(
      listener: (context, state) {
        if (state is SchoolRemoved) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 15.h, top: 15.v),
                padding: EdgeInsets.symmetric(vertical: 54.v, horizontal: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 44.v),
                    InkWell(
                      borderRadius: BorderRadius.circular(29.h),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SchoolDetails(school: user.school!);
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
                          profile: "School Details",
                          icon: ImageConstant.imgFavorite,
                          fill: IconButtonStyleHelper.fillindigoA400,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.v),
                    InkWell(
                      borderRadius: BorderRadius.circular(29.h),
                      onTap: () {
                        
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return UpdateSchool(school: user.school!);
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
                          profile: "Modify Your School",
                          icon: ImageConstant.imgFavorite,
                          fill: IconButtonStyleHelper.fillindigoA400,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                    InkWell(
                      borderRadius: BorderRadius.circular(29.h),
                      onTap: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: AppColors.indigoA200,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Are you sure you want to delete this School?',
                                style: TextStyle(color: Colors.black54),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'DELETE',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm == true) {
                          context
                              .read<ClassCubit>()
                              .removeSchool(user.school!.id);
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
                          profile: "Delete Your School",
                          icon: ImageConstant.imgClose,
                          fill: IconButtonStyleHelper.fillLightGreen,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                    InkWell(
                      borderRadius: BorderRadius.circular(29.h),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DefaultWidget();
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
                          profile: "School Verification",
                          icon: ImageConstant.imgBookmarkOrange300,
                          fill: IconButtonStyleHelper.fillOrange,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                    InkWell(
                      borderRadius: BorderRadius.circular(29.h),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DefaultWidget();
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
                          icon: ImageConstant.imgBoldDuotoneEssentional,
                          fill: IconButtonStyleHelper.fillRed,
                          profile: "Manage Members",
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                  ],
                ),
              ),
            ),
          ),
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
