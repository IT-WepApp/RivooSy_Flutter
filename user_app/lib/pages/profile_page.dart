import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_services/user_service.dart';
import 'package:shared_widgets/theme/colors.dart';
import 'package:user_app/utils/user_constants.dart';
import 'package:shared_models/shared_models.dart'; // نموذج المستخدم

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
        title: const Text(UserConstants.appTitle),
        backgroundColor: AppColors.primary,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildUserInfo(),
      ),
    );
  }

  Widget _buildUserInfo() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return const Center(child: Text('No authenticated user.'));
    }

    return FutureBuilder<UserModel?>(
      future: UserService().getUser(firebaseUser.uid),
      builder: (context, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('User data not found.');
        }

        final userModel = snapshot.data!;  // الآن يُستخدم المتغير
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userModel.name}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${userModel.email}', style: const TextStyle(fontSize: 18)),
          ],
        );
      },
    );
  }
}
