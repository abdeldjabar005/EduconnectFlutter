import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/injection_container.dart';

class Join extends StatefulWidget {
  Join({Key? key, required this.type})
      : super(
          key: key,
        );

  String type;

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  String errorMessage = '';
  TextEditingController codeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context2) {
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
          backgroundColor: AppColors.gray200,
          appBar: AppBar(
            backgroundColor: AppColors.whiteA700,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Join a ${widget.type == "school" ? "School" : "Class"}",
              style: TextStyle(
                fontFamily: "Poppins",
                color: AppColors.black900,
                fontWeight: FontWeight.w400,
                fontSize: 18.v,
              ),
            ),
          ),
          body: BlocConsumer<ClassCubit, ClassState>(
            listener: (context, state) {
              if (state is ClassError) {
                setState(() {
                  errorMessage = state.message;
                });
              } else if (state is ClassLoaded) {
                SnackBar(
                  content: const Text("Joined successfully"),
                  backgroundColor: AppColors.black900,
                );
                // Navigator.pop(context);
              } else if (state is SchoolLoaded) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              // log(state.toString());
              return Navigator(
                key: navigatorKey,
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      if (widget.type == "school") {
                        return _buildJoinSchool(context2, state);
                      } else {
                        return _buildJoinClass(context2, state);
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

  Widget _buildJoinSchool(BuildContext context, ClassState state) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 24.v, horizontal: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomImageView(
                  // imagePath: ImageConstant.imgArrowRight,
                  imagePath: ImageConstant.imgSchool2,
                  height: 320.v,
                  width: 320.h,
                  margin: EdgeInsets.all(
                    5.v,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 14.h),
                  child: Text("Code",
                      style: CustomTextStyles.titleMediumPoppinsGray900),
                ),
              ),
              SizedBox(
                height: 10.v,
              ),
              _buildCode(context),
              SizedBox(
                height: 10.v,
              ),
              _buildError(context, sl.get<ClassCubit>().state),
              SizedBox(
                height: 30.v,
              ),
              _buildButton(context, "Join a School"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinClass(BuildContext context, ClassState state) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 24.v, horizontal: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomImageView(
                  // imagePath: ImageConstant.imgArrowRight,
                  imagePath: ImageConstant.imgClass2,
                  height: 320.v,
                  width: 320.h,
                  margin: EdgeInsets.all(
                    5.v,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 14.h),
                  child: Text("Code",
                      style: CustomTextStyles.titleMediumPoppinsGray900),
                ),
              ),
              SizedBox(
                height: 10.v,
              ),
              _buildCode(context),
              SizedBox(
                height: 10.v,
              ),
              _buildError(context, sl.get<ClassCubit>().state),
              SizedBox(
                height: 30.v,
              ),
              _buildButton(context, "Join a Class"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCode(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.h, right: 15.h),
      child: CustomTextFormField(
        textStyle: TextStyle(
          fontFamily: "Poppins",
          color: AppColors.black900,
          fontWeight: FontWeight.w700,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              errorMessage = "Code cannot be empty";
            });
            return "Code cannot be empty";
          }
          return null;
        },
        borderDecoration: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray300,
            width: 1.5,
          ),
        ),
        controller: codeController,
        hintText: "Enter the code",
        textInputType: TextInputType.text,
        contentPadding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText) {
    ClassState state = context.watch<ClassCubit>().state;
    log(state.toString());

    return Center(
      child: CustomElevatedButton(
        isLoading: state is ClassLoading,
        height: 41.v,
        width: 143.h,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            setState(() {
              errorMessage = "";
            });
            if (widget.type == "school") {
              context.read<ClassCubit>().joinSchool(codeController.text);
              // sl.get<ClassCubit>().joinSchool(codeController.text);
            } else {
              context.read<ClassCubit>().joinClass(codeController.text);
            }
          }
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
        buttonTextStyle: CustomTextStyles.titleMediumPoppins14,
      ),
    );
  }

  Widget _buildError(BuildContext context, ClassState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is ClassError
              ? Text(state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : errorMessage.isNotEmpty
                  ? Text(errorMessage,
                      style: CustomTextStyles.titleMediumPoppinsBluegray100)
                  : Container(),
        ],
      ),
    );
  }
}
