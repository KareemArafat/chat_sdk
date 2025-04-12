import 'package:chat_sdk/cubits/shard_cubit/shard_cubit.dart';
import 'package:chat_sdk/cubits/shard_cubit/shard_state.dart';
import 'package:chat_sdk/pages/home_page.dart';
import 'package:chat_sdk/pages/login_page.dart';
import 'package:chat_sdk/shardP/app_loading_screen.dart';
import 'package:chat_sdk/shardP/shard_p_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShardCubit>(context).check();
  }

  getToken() async {
    String token = await ShardpModel().getToken();
    HomePage(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShardCubit, ShardState>(
      builder: (context, state) {
        if (state is CheckFailure) {
          return const LoginPage();
        } else if (state is CheckSuccess) {
          return HomePage(token: state.token);
        } else {
          return const AppLoadingScreen();
        }
      },
    );
  }
}
