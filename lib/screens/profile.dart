import 'package:flutter/material.dart';
import 'package:mycamp/update_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.home),
        ),
        title: Text(
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
                  Column(
                    children: [
                      UsernameTxt(),
                      emailTxt(),
                    ],
                  ),
                ],
              ),
              SpacerH30(),
              Divider(),
              SpacerH30(),
              Text(
                '\t\t\tMy Account',
                style: TextStyle(fontSize: 18),
              ),
              SpacerH30(),
              Profile_widget(
                  title: "Edit Profile",
                  icon: Icons.edit_note_outlined,
                  iconsize: 35,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfile(),
                      ),
                    );
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
          onPressed: () {},
          child: const Center(
            child: Text('Log Out'),
          ),
        ),
      ),
    );
  }

  SizedBox SpacerH30() {
    return SizedBox(
      height: 30,
    );
  }

  Text emailTxt() {
    return Text(
      'Email Address',
      style: TextStyle(fontSize: 12),
    );
  }

  Text UsernameTxt() {
    return Text(
      'Username',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      maxLines: 2,
    );
  }

  SizedBox ProfilePhoto_Widget() {
    return SizedBox(
      width: 150,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage('assets/yanliu.png'),
        ),
      ),
    );
  }

  SizedBox SpacerH10() {
    return SizedBox(
      height: 10,
    );
  }

  SizedBox SpacerW50() {
    return SizedBox(
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
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.withOpacity(0.4)),
        child: Icon(
          icon,
          size: iconsize,
        ),
      ),
      title: Text(title),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1)),
        child: Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
