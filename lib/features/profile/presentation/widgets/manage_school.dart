import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/core/widgets/custom_icon_button.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/pages/school_details.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/presentation/widgets/school_verified.dart';
import 'package:educonnect/features/profile/presentation/widgets/update_school.dart';
import 'package:educonnect/features/profile/presentation/widgets/verification_pending.dart';
import 'package:educonnect/features/profile/presentation/widgets/verify_school.dart';

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
            appBar: AppBar(
              leading: BackButton(
                color: AppColors.black900,
              ),
              backgroundColor: AppColors.whiteA700,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate('manage_school')!,
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
                          profile: AppLocalizations.of(context)!
                              .translate('school_details')!,
                          icon: ImageConstant.details,
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
                          profile: AppLocalizations.of(context)!
                              .translate('edit_school')!,
                          icon: ImageConstant.edit,
                          fill: IconButtonStyleHelper.fillLightGreen500,
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
                                AppLocalizations.of(context)!
                                    .translate('confirm')!,
                                style: TextStyle(
                                    color: AppColors.indigoA200,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                AppLocalizations.of(context)!
                                    .translate('confirm_delete')!,
                                style: TextStyle(color: Colors.black54),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('delete')!,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('cancel')!,
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
                          profile: AppLocalizations.of(context)!
                              .translate('delete_school')!,
                          icon: ImageConstant.delete,
                          fill: IconButtonStyleHelper.fillLightGreen,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                    BlocBuilder<ClassCubit, ClassState>(
                      builder: (context, state) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(29.h),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                if (user.school?.isVerified == false &&
                                    user.school?.verificationRequest == false) {
                                  return VerifySchool();
                                } else if (user.school?.isVerified == false &&
                                    user.school?.verificationRequest == true) {
                                  return VerificationPending();
                                } else {
                                  return SchoolVerified();
                                }
                                // return ManageProfile();
                              },
                            ));
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              color: AppColors.whiteA700,
                              borderRadius: BorderRadius.circular(29.h),
                            ),
                            width:
                                356 * MediaQuery.of(context).size.width / 414,
                            child: _buildFrame(
                              context,
                              profile: AppLocalizations.of(context)!
                                  .translate('school_verification')!,
                              icon: ImageConstant.verify,
                              fill: IconButtonStyleHelper.gold,
                            ),
                          ),
                        );
                      },
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
                          icon: ImageConstant.members,
                          fill: IconButtonStyleHelper.blue,
                          profile: AppLocalizations.of(context)!
                              .translate('manage_members')!,
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
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Row(
      children: [
        CustomIconButton(
          height: 56.v,
          width: 58.h,
          padding: EdgeInsets.all(12.h),
          decoration: fill,
          child: CustomImageView(
            height: 55.v,
            width: 53.h,
            imagePath: icon,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 22.h,
            right: 22.h,
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
          imagePath:
              isRtl ? ImageConstant.imgArrowLeft2 : ImageConstant.imgArrowRight,
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
