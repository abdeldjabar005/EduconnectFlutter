import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/pages/school_details.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/presentation/widgets/add_school.dart';

class ManageSchools extends StatefulWidget {
  const ManageSchools({Key? key})
      : super(
          key: key,
        );

  // String type;

  @override
  _ManageSchoolsState createState() => _ManageSchoolsState();
}

class _ManageSchoolsState extends State<ManageSchools>
     {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.gray200,
          appBar: AppBar(
            leading: BackButton(
              color: AppColors.black900,
            ),
            backgroundColor: AppColors.whiteA700,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Manage Schools",
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
                padding: EdgeInsets.symmetric(vertical: 10.v, horizontal: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddSchool(),
                        ),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteA700,
                            borderRadius: BorderRadius.circular(10.h),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15.h, vertical: 10.v),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.h, vertical: 25.v),
                          child: Row(
                            children: [
                              Text(
                                "Add a School ...",
                                style: CustomTextStyles.bodyMediumRobotoGray2
                                    .copyWith(
                                  color: AppColors.black900,
                                  fontSize: 18.v,
                                ),
                              ),
                              Spacer(),
                              Icon(FontAwesomeIcons.plus),
                            ],
                          )),
                    ),
                    SizedBox(height: 10.v),
                    _buildDivider2(context, "My School"),
                    SizedBox(height: 10.v),
                     BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      final user = (context.watch<AuthCubit>().state
                              as AuthAuthenticated)
                          .user;
                      List<SchoolModel> schools = user.schools;
                    // TODO: return the owned schools
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: schools.length,
                        itemBuilder: (context, index) {
                          return _buildSchoolItem(context, schools[index]);
                        },
                      );
                    },
                  ),
                    BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      if (state is SchoolLoaded) {}
                      return ValueListenableBuilder<List<SchoolModel>>(
                          valueListenable:
                              context.read<ClassCubit>().schoolCache,
                          builder: (context, List<SchoolModel> value, _) {
                            log(value.toString());
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return _buildSchoolItem(context, value[index]);
                              },
                            );
                          });
                    },
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolItem(BuildContext context, SchoolModel school) {
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
