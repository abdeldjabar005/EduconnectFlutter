// post_screen.dart
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/data/models/member_model.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/members_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/data/models/child2_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MembersScreen extends StatefulWidget {
  final int id;
  final String type;
  const MembersScreen({Key? key, required this.id, required this.type})
      : super(key: key);

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

enum ActionItems { delete, update }

class _MembersScreenState extends State<MembersScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.type == "school") {
      context.read<MembersCubit>().getMembers(widget.id);
    } else {
      context.read<MembersCubit>().getMembers2(widget.id);
    }
  }

  Map<String, String> roleTranslations = {
    'parent': 'والد',
    'teacher': 'معلم',
    'admin': 'مدير',
  };
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.gray200,
      body: BlocBuilder<MembersCubit, MembersState>(
        builder: (context, state) {
          if (state is MembersLoaded) {
            return ListView.builder(
              itemCount: state.members.length,
              itemBuilder: (context, index) {
                final member = state.members[index];
                return _buildMember(member);
              },
            );
          } else if (state is NoMembers) {
            return Center(child: Text(state.message));
          } else if (state is MembersError) {
            return Center(child: Text(state.message));
          } else if (state is MembersLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildMember(MemberModel member) {
    final currentUser =
        (context.read<AuthCubit>().state as AuthAuthenticated).user;
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final items = <ActionItems, String>{
      ActionItems.delete: isRtl ? 'حذف' : 'Delete',
    };
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 500.v,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 13.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: '${EndPoints.storage}${member.image}',
                              radius: BorderRadius.circular(50),
                              height: 60.v,
                              width: 60.v,
                            ),
                            Text(
                              "${member.firstName} ${member.lastName}",
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                            Text(
                              member.bio ??
                                  AppLocalizations.of(context)!
                                      .translate('no_bio')!,
                              style: CustomTextStyles.bodyMediumRobotoGray700,
                              softWrap: true,
                            ),
                            Text(
                              member.contact ??
                                  AppLocalizations.of(context)!
                                      .translate('no_contact')!,
                              style: CustomTextStyles.bodyMediumRobotoGray700,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      if (currentUser.id != member.id)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gray250,
                          ),
                          onPressed: () {
                            // TODO: Implement message functionality
                          },
                          child: Text(
                            AppLocalizations.of(context)!.translate('message')!,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (member.role == 'parent') ...[
                    Text(
                      AppLocalizations.of(context)!
                          .translate('associated_children')!,
                      style: CustomTextStyles.titleMediumPoppinsGray900,
                    ),
                    Divider(),
                    Flexible(
                      child: member.children.isEmpty
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('no_associated_children')!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: member.children.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 90,
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
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
                                                  AppColors.gray100,
                                              child:
                                                  Icon(size: 32, Icons.person),
                                            ),
                                            const SizedBox(width: 15),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ("${member.children[index].firstName} ${member.children[index].lastName}")
                                                              .length >
                                                          20
                                                      ? '${("${member.children[index].firstName} ${member.children[index].lastName}").substring(0, 20)}...'
                                                      : "${member.children[index].firstName} ${member.children[index].lastName}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${AppLocalizations.of(context)!.translate('son')!}: ${member.firstName} ${member.lastName}',
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
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: 90.v,
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 8,
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: '${EndPoints.storage}${member.image}',
                    radius: BorderRadius.circular(50),
                    height: 53.v,
                    width: 53.v,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ("${member.firstName} ${member.lastName}").length > 20
                            ? '${("${member.firstName} ${member.lastName}").substring(0, 20)}...'
                            : "${member.firstName} ${member.lastName}",
                        style: CustomTextStyles.titleMediumPoppinsGray900,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        member.children.isEmpty
                            ? (isRtl
                                ? roleTranslations[member.role] ?? 'مستخدم'
                                : member.role)
                            : getChildrenString(member.children, context),
                        style: CustomTextStyles.bodyMediumRobotoGray700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 5,
              top: 24,
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Message(id: id),
                  //   ),
                  // );
                },
                child: const Icon(FontAwesomeIcons.message),
              ),
              // child: PopupMenuButton<ActionItems>(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //     onSelected: (value) async {
              //       switch (value) {
              //         case ActionItems.delete:
              //           final confirm = await showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //                 title: Text(
              //                   AppLocalizations.of(context)!
              //                       .translate('confirm')!,
              //                   style: TextStyle(
              //                       color: AppColors.indigoA200,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //                 content: Text(
              //                   AppLocalizations.of(context)!
              //                       .translate('confirm_remove_member')!,
              //                   style: TextStyle(color: Colors.black54),
              //                 ),
              //                 actions: <Widget>[
              //                   TextButton(
              //                     onPressed: () =>
              //                         Navigator.of(context).pop(true),
              //                     child: Text(
              //                       AppLocalizations.of(context)!
              //                           .translate('remove')!,
              //                       style: TextStyle(color: Colors.red),
              //                     ),
              //                   ),
              //                   TextButton(
              //                     onPressed: () =>
              //                         Navigator.of(context).pop(false),
              //                     child: Text(
              //                       AppLocalizations.of(context)!
              //                           .translate('cancel')!,
              //                       style: TextStyle(color: Colors.blue),
              //                     ),
              //                   ),
              //                 ],
              //               );
              //             },
              //           );
              //           if (confirm == true) {
              //             context
              //                 .read<MembersCubit>()
              //                 .removeMember(widget.id, member.id, widget.type);
              //           }
              //           break;
              //       }
              //     },
              //     itemBuilder: (context) => [
              //           if (member.id != currentUser.id)
              //             PopupMenuItem<ActionItems>(
              //               value: ActionItems.delete,
              //               child: ListTile(
              //                 contentPadding: EdgeInsets.zero,
              //                 leading: Icon(Icons.delete,
              //                     color: AppColors.indigoA200),
              //                 title: Text('delete'),
              //               ),
              //             ),
              //         ]),
            ),
          ],
        ),
      ),
    );
  }

  String getChildrenString(List<Child2Model> children, BuildContext context) {
    Map<String, List<String>> relations = {};

    for (var child in children) {
      if (relations.containsKey(child.relation)) {
        relations[child.relation]!.add(child.firstName);
      } else {
        relations[child.relation] = [child.firstName];
      }
    }
    const maxRelations = 2;
    const maxChildrenPerRelation = 2;

    List<String> limitedRelations = [];
    int relationCount = 0;

    for (var entry in relations.entries) {
      if (relationCount >= maxRelations) break;

      List<String> childrenNames = entry.value;
      if (childrenNames.length > maxChildrenPerRelation) {
        childrenNames = childrenNames.sublist(0, maxChildrenPerRelation);
        childrenNames.add('...');
      }

      String translatedRelation =
          AppLocalizations.of(context)!.translate(entry.key)!;
      limitedRelations.add(
          '$translatedRelation ${AppLocalizations.of(context)!.translate("of")!} ${childrenNames.join(', ')}');
      relationCount++;
    }

    return limitedRelations.join(', ');
  }
}
