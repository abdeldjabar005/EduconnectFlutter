// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:quotes/core/utils/app_strings.dart';

// class SignUpPage extends StatelessWidget {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   SignUpPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text(AppStrings.signup)),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: AppStrings.email),
//                 ),
//                 TextField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(labelText: AppStrings.password),
//                   obscureText: true,
//                 ),
//                 ElevatedButton(
//                   onPressed: state is! AuthLoading
//                       ? () {
//                           context.read<AuthCubit>().signUp(
//                                 _emailController.text,
//                                 _passwordController.text,
//                               );
//                         }
//                       : null,
//                   child: state is AuthLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Sign Up'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }