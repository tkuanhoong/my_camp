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
              SpacerH(30),
              //a profile image edit widget
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
//spacer
              SpacerH(30),

              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        floatingLabelStyle: TextStyle(color: Colors.indigo),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                        ),
                        label: Text('Fullname'),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SpacerH(15),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        floatingLabelStyle: TextStyle(color: Colors.indigo),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                        ),
                        label: Text('Email'),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ],
                ),
              ),
              //button update profile
              SpacerH(40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Update Profile'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              SpacerH(50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text.rich(
                    TextSpan(
                      text: 'Joined',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: ' at 2021-08-20',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.redAccent.withOpacity(0.1),
                  //     elevation: 0,
                  //     foregroundColor: Colors.red,
                  //     shape: const StadiumBorder(),
                  //     side: BorderSide.none,
                  //   ),
                  //   child: Text('Delete'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// sizedbox parsing function
SpacerH(double a) {
  return SizedBox(
    height: a,
  );
}
