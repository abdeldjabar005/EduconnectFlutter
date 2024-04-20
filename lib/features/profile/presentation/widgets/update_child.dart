import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/presentation/cubit/children_cubit.dart';
import 'package:quotes/injection_container.dart';

class UpdateChild extends StatefulWidget {
  ChildModel child;
  UpdateChild({Key? key, required this.child})
      : super(
          key: key,
        );

  @override
  _UpdateChildState createState() => _UpdateChildState();
}

class _UpdateChildState extends State<UpdateChild> {
  String errorMessage = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();
  @override
  void initState() {
    firstNameController.text = widget.child.firstName;
    lastNameController.text = widget.child.lastName;
    selectedGrade = widget.child.grade;
    selectedRealtion = widget.child.relation;
    super.initState();
  }

  String selectedGrade = '';
  String selectedRealtion = '';
  List<String> relation = [
    "Father",
    "Mother",
    "Brother",
    "Sister",
    "Other",
  ];
  List<String> grade = [
    "1st grade",
    "2nd grade",
    "3rd grade",
    "4th grade",
    "5th grade",
    "6th grade",
    "7th grade",
    "8th grade",
    "9th grade",
    "10th grade",
    "11th grade",
    "12th grade",
  ];

  @override
  Widget build(BuildContext context2) {
    return BlocConsumer<ChildrenCubit, ChildrenState>(
      listener: (context, state) {
        log(state.toString());
        if (state is ChildrenLoaded) {
          Navigator.pop(context2);
        }
      },
      builder: (context, state) {
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
                  "Add a Child",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.black900,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.v,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.h,
                      vertical: 15.v,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28.v),
                        _buildFiftyOne(context),
                        SizedBox(height: 28.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            "Grade level",
                            style: CustomTextStyles.titleMediumPoppinsGray900,
                          ),
                        ),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: CustomDropDown(
                            value: selectedGrade,
                            textStyle: TextStyle(
                              fontFamily: "Poppins",
                              color: AppColors.black900,
                              fontWeight: FontWeight.w700,
                            ),
                            borderDecoration: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.gray300,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 21.h, vertical: 15.v),
                            icon: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 18.v, 9.h, 18.v),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgArrowdown,
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                              ),
                            ),
                            suffix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.h, 18.v, 12.h, 18.v),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgArrowdown,
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                              ),
                            ),
                            hintText: "Select Grade level",
                            hintStyle:
                                CustomTextStyles.titleMediumPoppinsGray40001,
                            items: grade,
                            onChanged: (String newValue) {
                              setState(() {
                                selectedGrade = newValue;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 28.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            "Relation",
                            style: CustomTextStyles.titleMediumPoppinsGray900,
                          ),
                        ),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: CustomDropDown(
                            value: selectedRealtion,
                            textStyle: TextStyle(
                              fontFamily: "Poppins",
                              color: AppColors.black900,
                              fontWeight: FontWeight.w700,
                            ),
                            borderDecoration: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.gray300,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 21.h, vertical: 15.v),
                            icon: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 18.v, 9.h, 18.v),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgArrowdown,
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                              ),
                            ),
                            suffix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.h, 18.v, 12.h, 18.v),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgArrowdown,
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                              ),
                            ),
                            hintText: "Select Relation",
                            hintStyle:
                                CustomTextStyles.titleMediumPoppinsGray40001,
                            items: relation,
                            onChanged: (String newValue) {
                              setState(() {
                                selectedRealtion = newValue;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 45.v),
                        _buildContinue(context, state),
                        SizedBox(height: 8.v),
                        _buildError(context, state),
                        SizedBox(height: 8.v),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFiftyOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildName(context, "First Name", firstNameController),
          Container(
            width: 23.v,
          ),
          _buildName(context, "Last Name", lastNameController),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildName(
      BuildContext context, String text, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: CustomTextStyles.titleMediumPoppinsGray900,
            ),
            SizedBox(height: 12.v),
            CustomTextFormField(
              textStyle: TextStyle(
                fontFamily: "Poppins",
                color: AppColors.black900,
                fontWeight: FontWeight.w700,
              ),
              borderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.gray300,
                  width: 1.5,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
              textInputType: TextInputType.name,
              width: 200.h,
              controller: controller,
              hintText: text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinue(BuildContext context, state) {
    return CustomElevatedButton(
      onPressed: state is ChildrenLoading
          ? null
          : () {
              if (firstNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  selectedGrade.isNotEmpty &&
                  selectedRealtion.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  context.read<ChildrenCubit>().updateChild(
                        ChildModel(
                          id: widget.child.id,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          grade: selectedGrade,
                          relation: selectedRealtion,
                        ),
                      );
                }
              } else {
                setState(() {
                  errorMessage = 'Please fill all the fields';
                });
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
      isLoading: state is ChildrenLoading,
      text: "Continue",
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildError(BuildContext context, ChildrenState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is ChildrenError
              ? Text(
                  state.message.contains('Server Failure')
                      ? "Server error"
                      : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
