import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/features/profile/presentation/widgets/add_child.dart';
import 'package:educonnect/features/profile/presentation/widgets/update_child.dart';
import 'package:educonnect/injection_container.dart';

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
              AppLocalizations.of(context)!.translate('manage_children')!,
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
                                AppLocalizations.of(context)!
                                    .translate('add_child')!,
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
                          return Center(
                              child: Text(AppLocalizations.of(context)!
                                  .translate('children_empty')!));
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
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final items = <ActionItems, String>{
      ActionItems.delete: isRtl ? 'حذف' : 'Delete',
      ActionItems.update: isRtl ? 'تحديث' : 'Update',
    };
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
              Text(
                "${AppLocalizations.of(context)!.translate('grade_level')!} : ${AppLocalizations.of(context)!.translate(child.grade!)!}",
                style: CustomTextStyles.bodyMediumRobotoGray2.copyWith(
                  color: AppColors.black900.withOpacity(0.6),
                  fontSize: 14.v,
                ),
              )
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
                          AppLocalizations.of(context)!.translate('confirm')!,
                          style: TextStyle(
                              color: AppColors.indigoA200,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          AppLocalizations.of(context)!
                              .translate('delete_child')!,
                          style: TextStyle(color: Colors.black54),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('delete')!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('cancel')!,
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
