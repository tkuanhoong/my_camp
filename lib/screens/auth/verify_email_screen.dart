
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
   return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please check your email to verify your account', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("Awaiting Email Verification from ${widget.email}", textAlign: TextAlign.center,),
                  const SizedBox(
                    height: 12,
                  ),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(
                    height: 12,
                  ),
                  // ElevatedButton(onPressed: (){
                  //   context.read<AuthBloc>().add(ResendVerificationEmail(email:widget.email));
                  // }, child: Text('Resend Email'))
                ],
              ),
            );
  }
}