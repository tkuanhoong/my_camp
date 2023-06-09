import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:my_camp/screens/auth/verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            context.read<SessionCubit>().setUserSession();
            context.pushReplacementNamed('home');
          }
    
          if (state is AuthError) {
            // Displaying the error message if the user is not authenticated
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            // Displaying the loading indicator while the user is signing up
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VerifyingEmail) {
            return VerifyEmailScreen(email: state.email);
          }
          // Displaying the sign up form if the user is not authenticated
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Register your account",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Already have an account? ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        InkWell(
                          child: const Text("Login",
                              style: TextStyle(color: Colors.blue)),
                          onTap: () {
                            context.goNamed('login');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
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
                              height: 10,
                            ),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: "Username",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return value != null && value.length < 6 ||
                                        value != null && value.length > 20
                                    ? 'Min. 6 - Max. 20 characters'
                                    : null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return value != null && value.length < 6
                                    ? "Enter min. 6 characters"
                                    : null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _confirmPasswordController,
                              decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value != null &&
                                    _passwordController.text.isNotEmpty) {
                                  if (value.length < 6) {
                                    return "Enter min. 6 characters";
                                  } else if (value !=
                                      _passwordController.text) {
                                    return "Password doesn't match";
                                  }
                                }
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  _createAccountWithEmailAndPassword(context);
                                },
                                child: const Text('Register account'),
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
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              _emailController.text,
              _nameController.text,
              _passwordController.text,
            ),
          );
    }
  }
}
