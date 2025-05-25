import 'package:chat_sdk/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_sdk/cubits/auth_cubit/auth_states.dart';
import 'package:chat_sdk/pages/home_page.dart';
import 'package:chat_sdk/ui/custom_ui/custom_button.dart';
import 'package:chat_sdk/ui/custom_ui/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignPage extends StatelessWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? userName;
    String? userId;
    String? appToken;
    String? apiKey;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 31, 0, 62),
              Color.fromARGB(255, 112, 33, 186),
              Color.fromARGB(255, 31, 161, 216),
            ],
            stops: [0.3, 0.7, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
              if (state is LoginSuccess) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomePage(token: state.token, apiKey: state.apiKey),
                    ));
              }
            },
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Image.asset(
                    'assets/images/logo_image.png',
                    width: 130, // Set width
                    height: 130, // Set height
                  ),
                  const SizedBox(height: 10),
                  const Text("Chat SDK",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 35),
                  CustomField(
                    hint: 'User Name',
                    change: (p0) => userName = p0,
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hint: 'User Id',
                    change: (p0) => userId = p0,
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hint: 'App Token',
                    change: (p0) => appToken = p0,
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hint: 'Api Key',
                    change: (p0) => apiKey = p0,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    sign: 'Sign',
                    tap: () {
                      BlocProvider.of<AuthCubit>(context).signFn(
                          userName: userName!,
                          userId: userId!,
                          appToken: appToken!,
                          apiKey: apiKey!);
                    },
                  ),
                  const Spacer(flex: 3),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
