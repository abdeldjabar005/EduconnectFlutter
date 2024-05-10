import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/pages/school_details.dart';
import 'package:educonnect/features/classrooms/presentation/pages/main_classroom.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/injection_container.dart';

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
              "${AppLocalizations.of(context)!.translate("join_a") ?? "join a "}${widget.type == "school" ? AppLocalizations.of(context)!.translate("school")! : AppLocalizations.of(context)!.translate("class")!}",
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
              } else if (state is ClassLoaded || state is SchoolLoaded) {
                Navigator.pop(context2);
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
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

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
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Text(AppLocalizations.of(context)!.translate("code")!,
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
              _buildButton(context,
                  AppLocalizations.of(context)!.translate("join_school")!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinClass(BuildContext context, ClassState state) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

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
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Text(AppLocalizations.of(context)!.translate("code")!,
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
              _buildButton(context,
                  AppLocalizations.of(context)!.translate("join_class")!),
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
              // errorMessage =
              // AppLocalizations.of(context)!.translate("code_empty")!;
            });
            return AppLocalizations.of(context)!.translate("code_empty")!;
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
        hintText: AppLocalizations.of(context)!.translate("enter_code")!,
        textInputType: TextInputType.text,
        contentPadding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText) {
    ClassState state = context.watch<ClassCubit>().state;

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
              : errorMessage == "You are already enrolled in this class"
                  ? Text(
                      AppLocalizations.of(context)!
                          .translate("already_enrolled")!,
                      style: CustomTextStyles.titleMediumPoppinsBluegray100)
                  : errorMessage.isNotEmpty
                      ? Text(
                          AppLocalizations.of(context)!
                              .translate("wrong_code")!,
                          style: CustomTextStyles.titleMediumPoppinsBluegray100)
                      : Container(),
        ],
      ),
    );
  }
}
