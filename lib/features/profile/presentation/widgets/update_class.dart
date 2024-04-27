import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_image_pick.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:quotes/features/classrooms/data/models/class_m.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/profile/presentation/cubit/children_cubit.dart';
import 'package:image_picker/image_picker.dart';

class UpdateClass extends StatefulWidget {
  final ClassModel classe;
  UpdateClass({Key? key, required this.classe}) : super(key: key);

  @override
  _UpdateClassState createState() => _UpdateClassState();
}

class _UpdateClassState extends State<UpdateClass> {
  String errorMessage = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController classNameController = TextEditingController();

  TextEditingController subjectController = TextEditingController();

  @override
  void initState() {
    classNameController.text = widget.classe.name;
    subjectController.text = widget.classe.subject;
    selectedGrade = widget.classe.grade;
    selectedSchool = widget.classe.schoolId.toString();

    super.initState();
  }

  String selectedGrade = '';
  String selectedSchool = '';
  List<String> schools = [];

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

  XFile? selectedImage;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context2) {
    return BlocConsumer<ClassCubit, ClassState>(
      listener: (context, state) {
        log(state.toString());
        if (state is TeacherClassesLoaded) {
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
                  "Update a Class",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.black900,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.v,
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.h,
                    vertical: 15.v,
                  ),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.v),
                      _buildName(context, "Class Name", classNameController),
                      SizedBox(height: 20.v),
                      _buildName(context, "Subject", subjectController),
                      SizedBox(height: 20.v),
                      Padding(
                        padding: EdgeInsets.only(left: 3.h),
                        child: Text(
                          "Grade level",
                          style: CustomTextStyles.titleMediumPoppinsGray900,
                        ),
                      ),
                      SizedBox(height: 20.v),
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
                            margin: EdgeInsets.fromLTRB(30.h, 18.v, 9.h, 18.v),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgArrowdown,
                              height: 20.adaptSize,
                              width: 20.adaptSize,
                            ),
                          ),
                          suffix: Container(
                            margin: EdgeInsets.fromLTRB(10.h, 18.v, 12.h, 18.v),
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
                      SizedBox(height: 48.v),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              "Select New Image",
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              "(Optional)",
                              style:
                                  CustomTextStyles.titleMediumPoppinsGray40001,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.v),
                      InkWell(
                        onTap: pickImage,
                        child: selectedImage == null
                            ? Text('Select Image')
                            : Text(
                                'Image Selected: ${selectedImage!.path.split('/').last}'),
                      ),
                      SizedBox(height: 30.v),
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
        );
      },
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
              // width: 200.h,
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
              if (classNameController.text.isNotEmpty &&
                  subjectController.text.isNotEmpty &&
                  selectedGrade.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  File? image;
                  if (selectedImage != null) {
                    image = File(selectedImage!.path);
                  }
                  context.read<ClassCubit>().updateClass(
                        widget.classe.id,
                        ClassM(
                          name: classNameController.text,
                          grade: selectedGrade,
                          subject: subjectController.text,
                        ),
                        image,
                      );
                }
              } else {
                setState(() {
                  errorMessage = 'Please fill at least one field';
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
      isLoading: state is ClassLoading,
      text: "Continue",
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildError(BuildContext context, state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is ClassError
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