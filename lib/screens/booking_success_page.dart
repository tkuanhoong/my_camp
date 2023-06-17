import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle,color: Theme.of(context).primaryColor,size: MediaQuery.of(context).size.width * 0.25),
          const SizedBox(height: 20,),
          const Center(child: Text('Yay! We\'ve got your booking!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),          
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(onPressed: (){
                context.goNamed('home');
              }, icon: 
              const Icon(Icons.home), label: const Text('Back to Home')),
              TextButton.icon(onPressed: (){
                context.goNamed('bookings');
              }, icon: 
              const Icon(Icons.remove_red_eye), label: const Text('View My Bookings')),
            ],
          ),
        ]
      ),
    );
  }
}