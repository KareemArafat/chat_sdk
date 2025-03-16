import 'package:chat_sdk/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_sdk/cubits/auth_cubit/auth_states.dart';
import 'package:chat_sdk/pages/login_page.dart';
import 'package:chat_sdk/ui/custom_ui/custom_button.dart';
import 'package:chat_sdk/ui/custom_ui/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignPage extends StatelessWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? firstName;
    String? lastName;
    String? email;
    String? password;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is SignSuccess) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            }
            if (state is SignFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            if (state is SignLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/logo_image.png',
                    width: 130, // Set width
                    height: 130, // Set height
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Sign Up',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(height: 10),
                  CustomField(
                    hint: 'First Name',
                    change: (p0) => firstName = p0,
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hint: 'Last Name',
                    change: (p0) => lastName = p0,
                  ),
                  const SizedBox(height: 15),
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
                    sign: 'Sign Up',
                    tap: () {
                      BlocProvider.of<AuthCubit>(context).signFn(
                          firstName: firstName!,
                          lastName: lastName!,
                          email: email!,
                          password: password!);
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
                              return const LoginPage();
                            }));
                          },
                          child: const Text(
                            '  Login',
                            style: TextStyle(color: Colors.yellow, fontSize: 20,fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
