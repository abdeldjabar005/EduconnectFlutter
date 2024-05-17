import 'dart:async';

import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/assets_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  _goNext() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final isLoggedIn = await authCubit.autoLogin();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, Routes.rootScreen);
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    }
  }

  _startDelay() {
    _timer = Timer(const Duration(milliseconds: 2000), () => _goNext());
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        heightFactor: 3.6,
        child: Image.asset(ImageConstant.edu),
      ),
    );
  }
}
