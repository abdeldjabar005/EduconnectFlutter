import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/constants.dart';
import 'package:educonnect/core/widgets/Tab_Cubit.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabCubit(),
      child: _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody>
    with TickerProviderStateMixin {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, int>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: AppColors.gray500,
            appBar: AppBar(
              backgroundColor: AppColors.whiteA700,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSearchWidget(),
                  _buildEduConnectText(),
                  _buildMessengerWidget(),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: AnimatedBuilder(
                  animation: _tabController.animation!,
                  builder: (BuildContext context, Widget? child) {
                    double tabIndex = _tabController.animation!.value;
                    int roundedTabIndex = tabIndex.round();
                    return TabBar(
                      tabs: Constants.getHomeScreenTabs(roundedTabIndex, context),
                      controller: _tabController,
                      onTap: (index) {
                        context.read<TabCubit>().changeTab(index);
                      },
                    );
                  },
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: Constants.screens,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEduConnectText() => Text(
        'EduConnect',
        style: TextStyle(
          color: AppColors.indigoA400,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildSearchWidget() => InkWell(
        // onTap: () {
        //   Navigator.of(context).pushNamed(SearchScreen.routeName);
        // },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 10,
          ),
          child: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: AppColors.black900,
            size: 23,
          ),
        ),
      );

  Widget _buildMessengerWidget() => InkWell(
        // onTap: () {
        //   Navigator.of(context).pushNamed(NotificationScreen.routeName);
        // },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 10,
          ),
          child: FaIcon(
            FontAwesomeIcons.bell,
            color: AppColors.black900,
            size: 23,
          ),
        ),
      );
}
