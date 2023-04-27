import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_camp/widgets/otp_input.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

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
  void startTimer() {
    print('resended');
    _secondsToResendOTP = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) {
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
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
                const Text(
                  '+60 123456789',
                  style: TextStyle(
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
                          _validOtp!
                              ? print('submitted: $_otp')
                              : print('failed');
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
                      onPressed: () => startTimer(),
                      child: const Text('Resend OTP')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
