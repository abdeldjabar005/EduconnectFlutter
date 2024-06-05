import 'dart:developer';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/injection_container.dart';

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
    selectedGrade = widget.child.grade!;
    selectedRealtion = widget.child.relation!;
    super.initState();
  }

  String selectedGrade = '';
  String selectedRealtion = '';
  @override
  Widget build(BuildContext context2) {
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

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
                  AppLocalizations.of(context)!.translate('update_child_info')!,
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
                            AppLocalizations.of(context)!
                                .translate('grade_level')!,
                            style: CustomTextStyles.titleMediumPoppinsGray900,
                          ),
                        ),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: CustomDropDown(
                            value: AppLocalizations.of(context)!
                                .translate(selectedGrade)!,
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
                            hintText: AppLocalizations.of(context)!
                                .translate('select_grade_level')!,
                            hintStyle:
                                CustomTextStyles.titleMediumPoppinsGray40001,
                            items: grade
                                .map((gradeKey) => AppLocalizations.of(context)!
                                    .translate(gradeKey)!)
                                .toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                String englishGrade = grade.firstWhere(
                                    (gradeKey) =>
                                        AppLocalizations.of(context)!
                                            .translate(gradeKey)! ==
                                        newValue);
                                selectedGrade = englishGrade;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 28.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('relation')!,
                            style: CustomTextStyles.titleMediumPoppinsGray900,
                          ),
                        ),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: CustomDropDown(
                            value: AppLocalizations.of(context)!
                                .translate(selectedRealtion)!,
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
                            hintText: AppLocalizations.of(context)!
                                .translate('select_relation')!,
                            hintStyle:
                                CustomTextStyles.titleMediumPoppinsGray40001,
                            items: relation
                                .map((relationKey) =>
                                    AppLocalizations.of(context)!
                                        .translate(relationKey)!)
                                .toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                String englishRelation = relation.firstWhere(
                                    (relationKey) =>
                                        AppLocalizations.of(context)!
                                            .translate(relationKey)! ==
                                        newValue);
                                selectedRealtion = englishRelation;
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
          _buildName(
              context,
              AppLocalizations.of(context)!.translate('first_name')!,
              firstNameController),
          Container(
            width: 23.v,
          ),
          _buildName(
              context,
              AppLocalizations.of(context)!.translate('last_name')!,
              lastNameController),
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

                
              } else {
                setState(() {
                  errorMessage = AppLocalizations.of(context)!
                      .translate('fill_all_fields')!;
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
      text: AppLocalizations.of(context)!.translate('continue')!,
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
                      ? AppLocalizations.of(context)!.translate('server_error')!
                      : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
