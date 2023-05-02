import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:my_camp/widgets/otp_input.dart';

class Otp extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const Otp({super.key, required this.phoneNumber,required this.verificationId});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _field1 = TextEditingController();
  final TextEditingController _field2 = TextEditingController();
  final TextEditingController _field3 = TextEditingController();
  final TextEditingController _field4 = TextEditingController();
  final TextEditingController _field5 = TextEditingController();
  final TextEditingController _field6 = TextEditingController();
  late int _secondsToResendOTP;
  String? _otp;
  bool? _validOtp;
  Timer? _timer;

  void startTimer() {
    _secondsToResendOTP = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsToResendOTP--;
      });
      if (_secondsToResendOTP == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _field1.dispose();
    _field2.dispose();
    _field3.dispose();
    _field4.dispose();
    _field5.dispose();
    _field6.dispose();
    super.dispose();
  }

  void _verifyOtp({required BuildContext context}) {
    context.read<PhoneAuthBloc>().add(PhoneAuthOtpPendingVerified(
        otpCodeReceived: _otp!, verificationId: widget.verificationId));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocListener<PhoneAuthBloc, PhoneAuthState>(
        listener: (_, state) {
          if (state is PhoneAuthVerifySuccess) {
            _timer!.cancel();
            context.pushReplacementNamed('home');
          }
          if(state is PhoneAuthCodeSentSuccess){
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('OTP Sent')));
          }
          if (state is PhoneAuthVerifyFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter OTP',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF3F3D56),
                        height: 1.0),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We have sent an One Time Password (OTP) to your phone number via SMS',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(widget.phoneNumber,
                    style: const TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF3F3D56),
                        height: 1.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpInput(controller: _field1, autoFocus: true),
                      OtpInput(controller: _field2),
                      OtpInput(controller: _field3),
                      OtpInput(controller: _field4),
                      OtpInput(controller: _field5),
                      OtpInput(controller: _field6),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (_validOtp == false)
                    Text(
                      'Please fill out all 6 numbers.',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            _otp = _field1.text +
                                _field2.text +
                                _field3.text +
                                _field4.text +
                                _field5.text +
                                _field6.text;
                            _validOtp = _otp!.trim().length == 6;
                            if(_validOtp == true){
                              _verifyOtp(context: context);
                            }
                          }),
                      child: const Text('Submit')),
                  if (_secondsToResendOTP > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text('Resend OTP (${_secondsToResendOTP}s)',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    )
                  else
                    TextButton(
                        onPressed: () {
                          startTimer();
                          context.read<PhoneAuthBloc>().add(
                              PhoneAuthOtpRequested(
                                  phoneNumber: widget.phoneNumber));
                        },
                        child: const Text('Resend OTP')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
