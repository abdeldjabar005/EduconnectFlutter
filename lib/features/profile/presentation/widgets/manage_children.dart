import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/presentation/cubit/children_cubit.dart';
import 'package:quotes/features/profile/presentation/widgets/add_child.dart';
import 'package:quotes/features/profile/presentation/widgets/update_child.dart';
import 'package:quotes/injection_container.dart';

class ManageChildren extends StatefulWidget {
  const ManageChildren({Key? key})
      : super(
          key: key,
        );

  // String type;

  @override
  _ManageChildrenState createState() => _ManageChildrenState();
}

enum ActionItems { delete, update }

final items = <ActionItems, String>{
  ActionItems.delete: 'Delete',
  ActionItems.update: 'Update',
};

class _ManageChildrenState extends State<ManageChildren> {
  @override
  void initState() {
    super.initState();
    context.read<ChildrenCubit>().getChildren();

    // sl<ChildrenCubit>().getChildren();
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
              "Manage Children",
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
                          builder: (context) => const AddChild(),
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
                                "Add a Child ...",
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
                    BlocBuilder<ChildrenCubit, ChildrenState>(
                      builder: (context, state) {
                        if (state is ChildrenLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.children.length,
                            itemBuilder: (context, index) {
                              return _childItem(state.children[index], context);
                            },
                          );
                        } else if (state is ChildrenEmpty) {
                          return Center(child: Text(state.message));
                        } else if (state is ChildrenError) {
                          return Center(child: Text(state.message));
                        } else if (state is ChildrenLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    // BlocBuilder<ChildrenCubit, ChildrenState>(
                    //   builder: (context, state) {
                    //     if (state is ChildAdded) {}
                    //     return ValueListenableBuilder<List<ChildModel>>(
                    //         valueListenable:
                    //             context.read<ChildrenCubit>().childrenCache,
                    //         builder: (context, List<ChildModel> value, _) {
                    //           log(value.toString());
                    //           return ListView.builder(
                    //             shrinkWrap: true,
                    //             physics: NeverScrollableScrollPhysics(),
                    //             itemCount: value.length,
                    //             itemBuilder: (context, index) {
                    //               return _childItem(value[index]);
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

  Widget _childItem(ChildModel child, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteA700,
        borderRadius: BorderRadius.circular(10.h),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.v),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${child.firstName} ${child.lastName}",
                style: CustomTextStyles.bodyMediumRobotoGray2.copyWith(
                  color: AppColors.black900,
                  fontSize: 16.v,
                ),
              ),
              Text("Grade level : ${child.grade}",
                  style: CustomTextStyles.bodyMediumRobotoGray2.copyWith(
                    color: AppColors.black900.withOpacity(0.6),
                    fontSize: 14.v,
                  )),
            ],
          ),
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
                    context.read<ChildrenCubit>().removeChild(child);
                  }
                  break;
                case ActionItems.update:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateChild(child: child)),
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
    );
  }
}
