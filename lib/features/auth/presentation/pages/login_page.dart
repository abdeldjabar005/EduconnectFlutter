// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quotes/config/routes/app_routes.dart';
// import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';

// import 'package:quotes/features/auth/presentation/pages/sign_up.dart';

// class LoginPage extends StatelessWidget {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.orangeAccent,
//               Colors.pinkAccent,
//             ],
//           ),
//         ),
//         child: BlocConsumer<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             } else if (state is AuthAuthenticated) {
//               Navigator.of(context).pushReplacementNamed(Routes.rootScreen);
//             }
//           },
//           builder: (context, state) {
//             return Column(
//               children: <Widget>[
//                 const SizedBox(height: 50),
//                 Image.asset('assets/images/edu.png'),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Sign in to your account',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your email',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your password',
//                     border: OutlineInputBorder(),
//                     suffixIcon: Icon(Icons.visibility_off),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: state is! AuthLoading
//                       ? () {
//                           context.read<AuthCubit>().login(
//                                 _emailController.text,
//                                 _passwordController.text,
//                               );
//                         }
//                       : null,
//                   child: state is AuthLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Login'),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     const Text(
//                       "I don't have an account",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => SignUpPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Sign up',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
