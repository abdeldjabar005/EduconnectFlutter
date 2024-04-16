// post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/classrooms/data/models/member_model.dart';
import 'package:quotes/features/classrooms/presentation/cubit/members_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

class MembersScreen extends StatefulWidget {
  final int id;
  final String type;
  const MembersScreen({Key? key, required this.id, required this.type}) : super(key: key);

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

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
    return Container(
      height: 100.v,
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
            top: 15,
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
                    Text(
                      member.role,
                      style: CustomTextStyles.bodyMediumRobotoGray700,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: 30,
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
          ),
        ],
      ),
    );
  }
}
