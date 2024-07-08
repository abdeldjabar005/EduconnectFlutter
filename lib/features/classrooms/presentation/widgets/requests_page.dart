import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/classrooms/data/models/request_model.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/members_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';

class RequestsPage extends StatefulWidget {
  final String type;
  final int id;
  RequestsPage({required this.type, required this.id});

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MembersCubit>().getRequests(widget.id, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.type == 'school'
              ? AppLocalizations.of(context)!.translate('school_requests')!
              : AppLocalizations.of(context)!.translate('class_requests')!),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<MembersCubit, MembersState>(
          builder: (context, state) {
            if (state is RequestsLoaded) {
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  RequestModel request = state.requests[index];
                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomImageView(
                            imagePath:
                                '${EndPoints.storage}${request.profilePicture}',
                            radius: BorderRadius.circular(30),
                            height: 50.h,
                            width: 50.v,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(request.name),
                            subtitle: Text(
                                '${request.firstName} ${request.lastName}'),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                context.read<MembersCubit>().acceptMember(
                                    request.id, widget.id, widget.type);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                context.read<MembersCubit>().refuseMember(
                                    request.id, widget.id, widget.type);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is NoRequests) {
              return Center(
                child: Text(
                    AppLocalizations.of(context)!.translate('no_requests')!),
              );
            } else if (state is MembersLoaded) {
              return Center(
                child: Text(
                    AppLocalizations.of(context)!.translate('no_requests')!),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
