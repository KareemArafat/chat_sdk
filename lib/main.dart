import 'package:chat_sdk/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/shard_cubit/shard_cubit.dart';
import 'package:chat_sdk/shardP/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatMe());
}

class ChatMe extends StatelessWidget {
  const ChatMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
        BlocProvider(
          create: (context) => ShardCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
        home: const Auth(),
      ),
    );
  }
}