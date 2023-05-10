import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/data/repository/auth_repository.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
// import 'package:mycamp/update_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pushReplacementNamed('home');
          },
          icon: const Icon(Icons.home),
        ),
        title: const Text(
          'Profile',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerH10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProfilePhoto_Widget(),
                  _buildUserInfo(),
                ],
              ),
              SpacerH30(),
              const Divider(),
              SpacerH30(),
              Container(
                margin: const EdgeInsets.only(left: 14),
                child: const Text(
                  'My Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SpacerH30(),
              Profile_widget(
                  title: "Edit Profile",
                  icon: Icons.edit_note_outlined,
                  iconsize: 35,
                  onPress: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => UpdateProfile(),
                    //   ),
                    // );
                  }),
              Profile_widget(
                title: "Settings",
                icon: Icons.settings,
                iconsize: 28,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
             BlocProvider.of<SessionCubit>(context).clearUserSession();
             BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
            context.goNamed('login');
          },
          child: const Center(
            child: Text('Log Out'),
          ),
        ),
      ),
    );
  }

  SizedBox SpacerH30() {
    return const SizedBox(
      height: 30,
    );
  }

  Text emailTxt() {
    return Text(
      context.read<SessionCubit>().state.email ?? 'User Email',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      maxLines: 2,
    );
  }

  Text UsernameTxt() {
    return Text(
        context.read<SessionCubit>().state.userName ?? 'User Name',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );
  }

  SizedBox _buildUserInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [UsernameTxt(), emailTxt()],
      ),
    );
  }

  SizedBox ProfilePhoto_Widget() {
    return SizedBox(
      width: 150,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: const Image(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }

  SizedBox SpacerH10() {
    return const SizedBox(
      height: 10,
    );
  }

  SizedBox SpacerW50() {
    return const SizedBox(
      width: 50,
    );
  }
}

class Profile_widget extends StatelessWidget {
  const Profile_widget({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconsize,
    required this.onPress,
    // this.endIcon = true,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final double iconsize;
  final VoidCallback onPress;
  // final bool endIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.indigo),
        child: Icon(
          icon,
          size: iconsize,
          color: Colors.white,
        ),
      ),
      title: Text(title),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.indigo),
        child: Icon(
          Icons.chevron_right_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
