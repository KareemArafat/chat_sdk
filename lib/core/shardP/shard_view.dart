import 'package:chat_sdk/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_sdk/cubits/auth_cubit/auth_states.dart';
import 'package:chat_sdk/pages/home_page.dart';
import 'package:chat_sdk/pages/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShardView extends StatefulWidget {
  const ShardView({super.key});

  @override
  State<ShardView> createState() => _ShardViewState();
}

class _ShardViewState extends State<ShardView> {
  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        if (state is CheckSuccess) {
          return HomePage(token: state.token, apiKey: state.apiKey);
        } else {
          return const SignPage();
        }
      },
    );
  }
}
