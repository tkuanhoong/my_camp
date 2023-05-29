import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/data/models/user_model.dart';
import 'package:my_camp/logic/blocs/bloc/profile_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel? user;
  @override
  void initState() {
    _nameController.text = context.read<SessionCubit>().state.userName!;
    _emailController.text = context.read<SessionCubit>().state.email!;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdatedSuccess) {
            context.read<SessionCubit>().updateUserSession(state.user);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is ProfileUpdateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            return SingleChildScrollView(
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
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //spacer
                    SpacerH(30),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            enabled: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: const Text('Email'),
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          SpacerH(15),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              label: Text('Fullname'),
                              prefixIcon: Icon(
                                Icons.person,
                              ),
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
                        ],
                      ),
                    ),
                    //button update profile
                    SpacerH(40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO Submit form [todo]
                          // if (_formKey.currentState!.validate()) {
                          //   context.read<ProfileBloc>().add(
                          //         ProfileUpdateRequested(
                          //           imagePath: '',
                          //           userId:
                          //               context.read<SessionCubit>().state.id!,
                          //           name: _nameController.text,
                          //         ),
                          //       );
                          // }
                        },
                        child: Text('Update Profile'),
                        style: ElevatedButton.styleFrom(
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
            );
          

          return Container();
        },
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
