import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';

class SchoolVerified extends StatelessWidget {
  const SchoolVerified({Key? key})
      : super(
          key: key,
        );

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
              "School is verified",
              style: TextStyle(
                fontFamily: "Poppins",
                color: AppColors.black900,
                fontWeight: FontWeight.w400,
                fontSize: 18.v,
              ),
            ),
          ),
          body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.v),
              Center(
                  child: Image.asset(ImageConstant.verify2,
                      height: 130.v, width: 130.v)),
              SizedBox(height: 40.v),
              Center(
                child: Text("Your school has been verified successfully",
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bodyMediumRobotoBlack),
              ),
              SizedBox(height: 20.v),
              Center(
                child: Text(
                  "Your school can now show up in the search results",
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyMediumRobotoBlack2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
