import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
        // if(state is ForgotPasswordSent){
        //   ScaffoldMessenger.of(context)
        //  .showSnackBar(const SnackBar(content: Text('Password reset email sent')));
        // }
      },
      builder: (_, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if (state is ForgotPasswordSent) {
        //   return Center(
        //     child: Padding(
        //       padding: const EdgeInsets.all(18.0),
        //       child: SingleChildScrollView(
        //         reverse: true,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Text(
        //               "We have sent an email to your email address.",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(
        //               height: 12,
        //             ),
        //             const Text(
        //               "Please check your email to reset your password.",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: 16,
        //               ),
        //             ),
        //             const SizedBox(
        //               height: 18,
        //             ),
        //             Center(
        //                 child: SizedBox(
        //               width: MediaQuery.of(context).size.width * 0.7,
        //               child: ElevatedButton(
        //                 onPressed: () {
        //                   context.replaceNamed('login');
        //                 },
        //                 child: const Text('Back to Login Screen'),
        //               ),
        //             )),
        //           ],
        //         ),
        //       ),
        //     ),
        //   );
        // }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Enter your email address to reset your password",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null &&
                                      !EmailValidator.validate(value)
                                  ? 'Enter a valid email'
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                            if (state is ForgotPasswordTicking) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 1.0,
                                child: Text(
                                    'Wait ${state.timeOutSeconds} seconds to resend',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.indigo)),
                              );
                            }
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 1.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  _sendForgotPasswordLink(context);
                                },
                                child: const Text('Send Password Reset Email'),
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 24,
                          ),
                          InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: const Text(
                              "Back to login",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  void _sendForgotPasswordLink(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        ForgotPasswordRequested(email: _emailController.text),
      );
    }
  }
}
