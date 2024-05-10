import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations_setup.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/core/utils/app_strings.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/members_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/like_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/features/splash/presentation/cubit/locale_cubit.dart';
import 'injection_container.dart' as di;

class EduApp extends StatelessWidget {
  const EduApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<AuthCubit>()),
          BlocProvider(
              create: (context) => di.sl<LocaleCubit>()..getSavedLang()),
          BlocProvider(create: (context) => di.sl<PostCubit>()),
          BlocProvider(create: (context) => di.sl<CommentsCubit>()),
          BlocProvider(create: (context) => di.sl<LikeCubit>()),
          BlocProvider(create: (context) => di.sl<ClassCubit>()),
          BlocProvider(create: (context) => di.sl<MembersCubit>()),
          BlocProvider(create: (context) => di.sl<Post2Cubit>()),
          BlocProvider(create: (context) => di.sl<ChildrenCubit>()),
        ],
        child: BlocBuilder<LocaleCubit, LocaleState>(
          buildWhen: (previousState, currentState) {
            return previousState != currentState;
          },
          builder: (context, state) {
            return Sizer(
              builder: (context, orientation, deviceType) {
                return MaterialApp(
                  title: AppStrings.appName,
                  theme: ThemeData(
                    popupMenuTheme: PopupMenuThemeData(
                      elevation: 2.0, // This controls the shadow.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ), // This controls the shape.
                    ),
                  ),
                  locale: state.locale,
                  debugShowCheckedModeBanner: false,
                  // theme: theme,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localeListResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                );
              },
            );
          },
        ));
  }
}
