import 'package:chat_sdk/cubits/shard_cubit/shard_cubit.dart';
import 'package:chat_sdk/cubits/shard_cubit/shard_state.dart';
import 'package:chat_sdk/pages/home_page.dart';
import 'package:chat_sdk/pages/login_page.dart';
import 'package:chat_sdk/services/shardP/app_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShardScreen extends StatefulWidget {
  const ShardScreen({super.key});

  @override
  State<ShardScreen> createState() => _ShardScreenState();
}

class _ShardScreenState extends State<ShardScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShardCubit>(context).check();
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
