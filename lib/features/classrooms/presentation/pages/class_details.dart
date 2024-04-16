import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/constants.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/Tab_Cubit.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

class ClassDetails extends StatefulWidget {
  final ClassModel classe;
  ClassDetails({Key? key, required this.classe}) : super(key: key);

  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              "Class",
              style: TextStyle(
                fontFamily: "Poppins",
                color: AppColors.black900,
                fontWeight: FontWeight.w400,
                fontSize: 18.v,
              ),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      CustomImageView(
                        imagePath: '${EndPoints.storage}${widget.classe.image}',
                        radius: BorderRadius.circular(30),
                        height: 205.v,
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(height: 10.v),
                      Text(
                        widget.classe.name,
                        style: CustomTextStyles.titleMediumPoppinsBlack2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.v),
                      Text(
                        "By ${widget.classe.teacherFirstName} ${widget.classe.teacherLastName} ",
                        style: CustomTextStyles.bodyMediumRobotoGray900,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.v),
                      PreferredSize(
                        preferredSize: const Size.fromHeight(kToolbarHeight),
                        child: AnimatedBuilder(
                          animation: _tabController.animation!,
                          builder: (BuildContext context, Widget? child) {
                            double tabIndex = _tabController.animation!.value;
                            int roundedTabIndex = tabIndex.round();
                            return TabBar(
                              tabs:
                                  Constants.getHomeScreenTabs3(roundedTabIndex),
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
            body: Container(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: Constants.screens3(widget.classe.id),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
