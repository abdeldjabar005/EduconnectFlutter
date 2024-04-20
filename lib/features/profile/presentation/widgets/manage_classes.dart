import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/classrooms/presentation/pages/class_details.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/presentation/cubit/children_cubit.dart';
import 'package:quotes/features/profile/presentation/widgets/add_child.dart';
import 'package:quotes/features/profile/presentation/widgets/add_class.dart';
import 'package:quotes/features/profile/presentation/widgets/update_class.dart';
import 'package:quotes/injection_container.dart';

class ManageClasses extends StatefulWidget {
  const ManageClasses({Key? key})
      : super(
          key: key,
        );

  // String type;

  @override
  _ManageClassesState createState() => _ManageClassesState();
}

enum ActionItems { delete, update }

final items = <ActionItems, String>{
  ActionItems.delete: 'Delete',
  ActionItems.update: 'Update',
};

class _ManageClassesState extends State<ManageClasses> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  late final ValueListenableBuilder<bool> childAddedListener;

  @override
  void initState() {
    super.initState();
    final user = (context.watch<AuthCubit>().state as AuthAuthenticated).user;
    context.read<ClassCubit>().getTeacherClasses(user.id, useCache: true);
  }

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
              "Manage Classes",
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
                          builder: (context) => const AddClass(),
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
                                "Add a Class ...",
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
                    _buildDivider2(context, "My Classes"),
                    SizedBox(height: 10.v),
                    BlocBuilder<ClassCubit, ClassState>(
                      builder: (context, state) {
                        if (state is TeacherClassesLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.classes.length,
                            itemBuilder: (context, index) {
                              return _buildClassItem(
                                  context, state.classes[index]);
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
                    // BlocBuilder<ClassCubit, ClassState>(
                    //   builder: (context, state) {
                    //     final user = (context.watch<AuthCubit>().state
                    //             as AuthAuthenticated)
                    //         .user;
                    //     List<ClassModel> classes = user.teacherClasses ?? [];

                    //     return ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: NeverScrollableScrollPhysics(),
                    //       itemCount: classes.length,
                    //       itemBuilder: (context, index) {
                    //         return _buildClassItem(context, classes[index]);
                    //       },
                    //     );
                    //   },
                    // ),
                    // BlocBuilder<ClassCubit, ClassState>(
                    //   builder: (context, state) {
                    //     if (state is ClassLoaded) {}
                    //     return ValueListenableBuilder<List<ClassModel>>(
                    //         valueListenable:
                    //             context.read<ClassCubit>().classCache,
                    //         builder: (context, List<ClassModel> value, _) {
                    //           log(value.toString());
                    //           return ListView.builder(
                    //             shrinkWrap: true,
                    //             physics: NeverScrollableScrollPhysics(),
                    //             itemCount: value.length,
                    //             itemBuilder: (context, index) {
                    //               return _buildClassItem(context, value[index]);
                    //             },
                    //           );
                    //         });
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, ClassModel classe) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClassDetails(classe: classe),
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
              imagePath: '${EndPoints.storage}${classe.image}',
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
                  classe.name,
                  style: CustomTextStyles.titleMediumPoppinsblacksmall.copyWith(
                    color: AppColors.black900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "By ${classe.teacherFirstName} ${classe.teacherLastName}",
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
            //const Icon(
            //FontAwesomeIcons.arrowRight,
            //color: Colors.black,
            //),
            PopupMenuButton<ActionItems>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (value) async {
                switch (value) {
                  case ActionItems.delete:
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
                            'Are you sure you want to delete this child?',
                            style: TextStyle(color: Colors.black54),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'DELETE',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
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
                      context.read<ClassCubit>().removeClass(classe.id);
                    }
                    break;
                  case ActionItems.update:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateClass(classe: classe)),
                    );
                    break;
                }
              },
              itemBuilder: (context) => items
                  .map((item, text) => MapEntry(
                      item,
                      PopupMenuItem<ActionItems>(
                        value: item,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                              item == ActionItems.delete
                                  ? Icons.delete
                                  : Icons.update,
                              color: AppColors.indigoA200),
                          title: Text(text),
                        ),
                      )))
                  .values
                  .toList(),
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
