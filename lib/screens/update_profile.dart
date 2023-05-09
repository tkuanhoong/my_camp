import 'package:flutter/material.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Fullname'),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
