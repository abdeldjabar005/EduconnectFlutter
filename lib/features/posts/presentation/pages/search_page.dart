import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/classrooms/presentation/pages/school_details.dart';
import 'package:educonnect/features/posts/data/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/features/posts/presentation/cubit/search_cubit.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.translate('search_schools')!,
              border: InputBorder.none,
            ),
            onSubmitted: (query) {
              BlocProvider.of<SearchCubit>(context).searchSchools(query);
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              if (state.schools.isEmpty) {
                return Center(child: Text(AppLocalizations.of(context)!.translate('no_schools_found')!));
              }
              return ListView.builder(
                itemCount: state.schools.length,
                itemBuilder: (context, index) {
                  final school =
                      convertSearchModelToSchoolModel(state.schools[index]);
                  return _buildSchool(
                      context, school, state.schools[index].isMember);
                },
              );
            } else if (state is SearchError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text(AppLocalizations.of(context)!.translate('search_for_schools')!));
          },
        ),
      ),
    );
  }

  Widget _buildSchool(BuildContext context, SchoolModel school, int isMember) {
    return InkWell(
      onTap: () {
        if (isMember == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchoolDetails(school: school),
            ),
          );
        } else if (isMember == 0) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  AppLocalizations.of(context)!.translate('join_request')!),
              content: Text(AppLocalizations.of(context)!
                  .translate('send_join_request')!),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.translate('no')!),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.translate('yes')!),
                  onPressed: () {
                    context.read<SearchCubit>().sendJoinRequest(school.id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  AppLocalizations.of(context)!.translate('join_request')!),
              content: Text(AppLocalizations.of(context)!
                  .translate('join_request_pending')!),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.translate('ok')!),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 100,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Stack(
          children: [
            Image.network(
              '${EndPoints.storage}/${school.image}',
              height: 114,
              width: 114,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 124,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    school.name.length > 26
                        ? '${school.name.substring(0, 26)}...'
                        : school.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'by ${school.adminFirstName} ${school.adminLastName}'
                                .length >
                            20
                        ? 'by ${("${school.adminFirstName} ${school.adminLastName}").substring(0, 20)}...'
                        : 'by ${school.adminFirstName} ${school.adminLastName}',
                    style: TextStyle(
                      color: Colors.black,
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
                isMember == 1
                    ? Icons.arrow_right
                    : isMember == 2
                        ? Icons.rotate_right
                        : Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SchoolModel convertSearchModelToSchoolModel(SearchModel searchModel) {
    return SchoolModel(
      id: searchModel.id,
      name: searchModel.name,
      address: searchModel.address,
      image: searchModel.image,
      adminId: searchModel.adminId,
      adminFirstName: searchModel.adminFirstName,
      adminLastName: searchModel.adminLastName,
      membersCount: searchModel.membersCount,
      isVerified: searchModel.isVerified,
      verificationRequest: searchModel.verificationRequest,
    );
  }
}
