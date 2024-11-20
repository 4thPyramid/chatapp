import 'package:chatapp/features/auth/presentation/views/wedgets/register_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/features/auth/presentation/cupits/register_cupit/regster_cubit.dart';
import 'package:chatapp/core/services/get_it_service.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegsterCubit>(),
      child: const Scaffold(
        body: RegisterViewBody(),
      ),
    );
  }
}
