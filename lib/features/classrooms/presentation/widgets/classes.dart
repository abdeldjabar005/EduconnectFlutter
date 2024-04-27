// post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/member_model.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

class ClassesScreen extends StatefulWidget {
  final int id;

  const ClassesScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ClassCubit>().getClasses(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.gray200,
      body: BlocBuilder<ClassCubit, ClassState>(
        builder: (context, state) {
          if (state is ClassesLoaded) {
            return ListView.builder(
              itemCount: state.classes.length,
              itemBuilder: (context, index) {
                final classe = state.classes[index].classModel;
                final isMember = state.classes[index].isMember;
                return _buildClass(classe, isMember);
              },
            );
          } else if (state is NoClasses) {
            return Center(child: Text(state.message));
          } else if (state is ClassError) {
            return Center(child: Text(state.message));
          } else if (state is ClassLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildClass(ClassModel classe, bool isMember) {
    return InkWell(
      onTap: () {
        // Your navigation code here
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
        child: Stack(
          children: [
            CustomImageView(
              imagePath: '${EndPoints.storage}${classe.image}',
              radius: BorderRadius.circular(30),
              height: 114.v,
              width: 114.h,
            ),
            Positioned(
              left: 124.h,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classe.name.length > 26
                        ? '${classe.name.substring(0, 26)}...'
                        : classe.name,
                    style:
                        CustomTextStyles.titleMediumPoppinsblacksmall.copyWith(
                      color: AppColors.black900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ("By ${classe.teacherFirstName} ${classe.teacherLastName}")
                                .length >
                            20
                        ? 'By ${("${classe.teacherFirstName} ${classe.teacherLastName}").substring(0, 20)}...'
                        : "By ${classe.teacherFirstName} ${classe.teacherLastName}",
                    style:
                        CustomTextStyles.titleMediumPoppinsblacksmall2.copyWith(
                      color: AppColors.black900,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 30,
              child: Icon(
                isMember ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.plus,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}