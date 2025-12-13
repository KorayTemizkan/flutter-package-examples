import 'package:example_firebase/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Changeinfos extends StatefulWidget {
  const Changeinfos({super.key});

  @override
  State<Changeinfos> createState() => _ChangeinfosState();
}

class _ChangeinfosState extends State<Changeinfos> {
  final TextEditingController passwordController = TextEditingController();
  bool isChanged = false;

  FirebaseAuth? auth;
  @override
  void initState() {
    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    try {
      await auth?.currentUser?.updatePassword(passwordController.text);
      isChanged = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
    } catch (e) {
      print('Anything else');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Change Password'),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),

            ElevatedButton(
              onPressed: () async {
                await changePassword();
                if (isChanged) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                }
              },
              child: Text('SaveNewPassword'),
            ),
          ],
        ),
      ),
    );
  }
}
