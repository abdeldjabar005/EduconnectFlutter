import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/routes/app_routes.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_strings.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'injection_container.dart' as di;

class QuoteApp extends StatelessWidget {
  const QuoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<AuthCubit>()),
          BlocProvider(create: (context) => di.sl<PostCubit>()),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previousState, currentState) {
            return previousState != currentState;
          },
          builder: (context, state) {
            return Sizer(
              builder: (context, orientation, deviceType) {
                return const MaterialApp(
                  title: AppStrings.appName,
                  debugShowCheckedModeBanner: false,
                  // theme: theme,
                  
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                );
              },
            );
          },
        ));
  }
}
