import 'package:chat_sdk/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_sdk/cubits/auth_cubit/auth_states.dart';
import 'package:chat_sdk/pages/home_page.dart';
import 'package:chat_sdk/pages/sign_page.dart';
import 'package:chat_sdk/ui/custom_button.dart';
import 'package:chat_sdk/ui/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomePage();
              }));
            }
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(flex: 1),
                Image.asset(
                  'assets/images/logo_image.png',
                  width: 130, // Set width
                  height: 130, // Set height
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Login",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 10),
                CustomField(
                  hint: 'Email',
                  change: (p0) => email = p0,
                ),
                const SizedBox(height: 15),
                CustomField(
                  obscure: true,
                  hint: 'Password',
                  change: (p0) => password = p0,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  sign: 'Login',
                  tap: () {
                    BlocProvider.of<AuthCubit>(context)
                        .loginFn(email: email!, password: password!);
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignPage();
                        }));
                      },
                      child: const Text(
                        '  Sign Up',
                        style: TextStyle(color: Colors.yellow, fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            );
          },
        ),
      ),
    );
  }
}
