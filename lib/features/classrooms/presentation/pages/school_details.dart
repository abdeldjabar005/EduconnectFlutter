import 'dart:developer';

import 'package:educonnect/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/constants.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/Tab_Cubit.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/widgets/join.dart';
import 'package:educonnect/features/classrooms/presentation/widgets/requests_page.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/injection_container.dart';

class SchoolDetails extends StatefulWidget {
  final SchoolModel school;
  SchoolDetails({Key? key, required this.school}) : super(key: key);

  @override
  _SchoolDetailsState createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: BlocProvider(
          create: (context) => TabCubit(),
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                color: AppColors.black900,
              ),
              backgroundColor: AppColors.whiteA700,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate('school')!,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: AppColors.black900,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.v,
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: AppColors.black900),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) async {
                    switch (value) {
                      case 'Associate Student':
                        if (user.role == 'parent') {
                          await context.read<ChildrenCubit>().getChildren();
                          final state = context.read<ChildrenCubit>().state;
                          if (state is ChildrenLoaded) {
                            final children = state.children;
                            if (context.mounted) {
                              final selectedChild =
                                  await showDialog<ChildModel>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .translate('select_child')!,
                                      style: TextStyle(
                                          color: AppColors.indigoA200,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Container(
                                      width: 200,
                                      height: 200,
                                      child: ListView.builder(
                                        itemCount: children.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title:
                                                Text(children[index].firstName),
                                            onTap: () => Navigator.of(context)
                                                .pop(children[index]),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (context.mounted) {
                                if (selectedChild != null &&
                                    selectedChild.id != null) {
                                  context.read<Post2Cubit>().associateStudent(
                                      selectedChild.id!,
                                      widget.school.id,
                                      'school');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .translate('invalid_selection')!),
                                      backgroundColor: const Color.fromARGB(
                                          255, 142, 111, 109),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        }
                        break;
                      case 'Students':
                        await context
                            .read<ClassCubit>()
                            .getStudents(widget.school.id, 'school');
                        final state = context.read<ClassCubit>().state;
                        if (state is StudentsLoaded) {
                          final students = state.students;
                          if (context.mounted) {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate('students_list')!,
                                        style: CustomTextStyles
                                            .titleMediumPoppinsBlack2,
                                      ),
                                      Divider(),
                                      Expanded(
                                        child: students.isEmpty
                                            ? Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          'no_students')!,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: students.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    height: 90,
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 0,
                                                          right: 0,
                                                          top: 8,
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 27,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .gray100,
                                                                child: Icon(
                                                                    size: 32,
                                                                    Icons
                                                                        .person),
                                                              ),
                                                              const SizedBox(
                                                                  width: 15),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    ("${students[index].firstName} ${students[index].lastName}").length >
                                                                            20
                                                                        ? '${("${students[index].firstName} ${students[index].lastName}").substring(0, 20)}...'
                                                                        : "${students[index].firstName} ${students[index].lastName}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    '${AppLocalizations.of(context)!.translate('parent')!}: ${students[index].parents[0].firstName} ${students[index].parents[0].lastName}',
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                        break;
                      case 'School Requests':
                        if (user.id == widget.school.adminId) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestsPage(
                                    id: widget.school.id, type: 'school'),
                              ),
                            );
                          }
                        }
                        break;
                         case 'Invite':
                        if (user.id == widget.school.adminId) {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)!
                                      .translate('invite_users')!),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)!
                                          .translate('to_invite_school')!),
                                      SizedBox(height: 10),
                                      SelectableText(
                                        widget.school.code!,
                                        style: CustomTextStyles.displayMedium45,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(AppLocalizations.of(context)!
                                          .translate('close')!),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                        break;
                      case 'Leave':
                        if (user.id != widget.school.adminId) {
                          if (context.mounted) {
                            final confirmLeave = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .translate('leave')!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .translate('confirm_leave')!,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('no')!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('yes')!,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmLeave == true) {
                              if (context.mounted) {
                                context
                                    .read<ClassCubit>()
                                    .leave(widget.school.id, 'school')
                                    .then((_) {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          }
                        }
                        break;
                      case 'Delete':
                        if (user.id == widget.school.adminId) {
                          if (context.mounted) {
                            final confirmLeave = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .translate('delete')!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .translate('confirm_delete')!,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('no')!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('yes')!,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmLeave == true) {
                              if (context.mounted) {
                                context
                                    .read<ClassCubit>()
                                    .removeSchool(widget.school.id)
                                    .then((_) {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          }
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (user.role == 'parent')
                      PopupMenuItem<String>(
                        value: 'Associate Student',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.person_add,
                              color: AppColors.indigoA200),
                          title: Text(AppLocalizations.of(context)!
                              .translate('associate_student')!),
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'Students',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.group, color: AppColors.indigoA200),
                        title: Text(AppLocalizations.of(context)!
                            .translate('students')!),
                      ),
                    ),
                    if (user.id == widget.school.adminId)
                      PopupMenuItem<String>(
                        value: 'School Requests',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              Icon(Icons.mail, color: AppColors.indigoA200),
                          title: Text(AppLocalizations.of(context)!
                              .translate('school_requests')!),
                        ),
                      ),
                       if (user.id == widget.school.adminId)
                      PopupMenuItem<String>(
                        value: 'Invite',  
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.add, color: AppColors.indigoA200),
                          title: Text(AppLocalizations.of(context)!
                              .translate('invite')!),
                        ),
                      ),
                    PopupMenuItem<String>(
                      value:
                          user.id == widget.school.adminId ? 'Delete' : 'Leave',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            const Icon(Icons.exit_to_app, color: Colors.red),
                        title: Text(user.id == widget.school.adminId
                            ? AppLocalizations.of(context)!
                                .translate('delete1')!
                            : AppLocalizations.of(context)!
                                .translate('leave1')!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: BlocConsumer<Post2Cubit, Post2State>(
              listener: (context, state) {
                if (state is AssociateStudentSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('child_associated')!),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is StudentAlreadyAssociated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('child_already_associated')!),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else if (state is MembersError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('child_already_associated')!),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            CustomImageView(
                              imagePath:
                                  '${EndPoints.storage}${widget.school.image}',
                              radius: BorderRadius.circular(30),
                              height: 205.v,
                              width: MediaQuery.of(context).size.width,
                            ),
                            SizedBox(height: 10.v),
                            Text(
                              widget.school.name,
                              style: CustomTextStyles.titleMediumPoppinsBlack2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.v),
                            Text(
                              "${widget.school.membersCount} ${AppLocalizations.of(context)!.translate('members')!}",
                              style: CustomTextStyles.bodyMediumRobotoGray900,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.v),
                            PreferredSize(
                              preferredSize:
                                  const Size.fromHeight(kToolbarHeight),
                              child: AnimatedBuilder(
                                animation: _tabController.animation!,
                                builder: (BuildContext context, Widget? child) {
                                  double tabIndex =
                                      _tabController.animation!.value;
                                  int roundedTabIndex = tabIndex.round();
                                  return TabBar(
                                    tabs: Constants.getHomeScreenTabs2(
                                        roundedTabIndex, context),
                                    controller: _tabController,
                                    onTap: (index) {
                                      context.read<TabCubit>().changeTab(index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: Constants.screens2(
                          widget.school.id, widget.school.name),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
