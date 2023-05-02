import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/logic/blocs/phone_auth/phone_auth_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp({required String phoneNumber, required BuildContext context}) {
    final String phoneNumberWithCode = '+60$phoneNumber';
    context.read<PhoneAuthBloc>().add(
          PhoneAuthOtpRequested(
            phoneNumber: phoneNumberWithCode,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PhoneAuthBloc, PhoneAuthState>(
        listener: (_, state) {
          if (state is PhoneAuthCodeSentSuccess) {
            context.pushReplacementNamed( 'otp', params: {'phoneNumber':'+60${_phoneController.text}','verificationId': state.verificationId});
          }
          if (state is PhoneAuthVerifyFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
            builder: (_, state) {
              if (state is PhoneAuthLoadInProgess) {
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Login Screen'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('+60'),
                        SizedBox(
                          width: 10.0,
                          height: 10.0,
                        ),
                        Expanded(
                          child: TextField(
                            maxLength: 12,
                            controller: _phoneController,
                            autofocus: false,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _sendOtp(
                              phoneNumber: _phoneController.text,
                              context: context);
                        },
                        child: const Text('Send OTP')),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
