import 'dart:developer';

import 'package:example_firebase/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'package:example_firebase/firebase_options.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuth?
  auth; // ? işareti dart dilinde değişkenin başlangıçta değerinin atanmamış veya nullable olmasını sağlar

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    //  // override : state sınıfında zaten var olan dispose metodunu kendim özelleştiriyorum demek
    emailController.dispose();
    passwordController.dispose();
    super
        .dispose(); // önce kendi temizliğini yaptın, şimdi de flutterin kendi dispose metodunu çağırıp iç temizliği yaptırdın
    // burayı böyle yapmamızın nedeni bu controllerler bellekte yer tutuyor ve ihtiyacımız olmadığında serbest bırakmak
  }

  Future<void> createUser() async {
    // Future bazı işlemleri eşzamansız (async) yapar, yani bu işlem ileride bir noktada tamamlanacak, bu fonksiyon çalışırken sen başka işlemler de yapabilirsin demek
    try {
      await auth?.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak!');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email!');
      }
    } catch (e) {
      print('Something went wrong!');
    }

    return;
  }

  Future<bool> login(bool deletable) async {
    try {
      await auth?.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (deletable == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found that email!');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user!');
      }
    }

    return true;
  }

  Future<void> deleteUser() async {
    await login(true);
    
    AuthCredential credential = EmailAuthProvider.credential(
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      print('Current user: ${auth?.currentUser}');
      await auth?.currentUser?.reauthenticateWithCredential(credential);
      print('Current user: ${auth?.currentUser}');
      await auth?.currentUser?.delete();
      print('deneme');
      print('Current user: ${auth?.currentUser}');

      print('User account has deleted!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('Recent login required!');
      } else if (e.code == 'user-mismatch') {
        print('User mismatch!');
      } else if (e.code == 'user-not-found') {
        print('User not found!');
      } else if (e.code == 'invalid-credential') {
        print('Invalid credential!');
      } else if (e.code == 'invalid-email') {
        print('Invalid email!');
      } else if (e.code == 'wrong-password') {
        print('Wrong password!');
      } else if (e.code == 'invalid-verification-code') {
        print('Invalid verification code!');
      } else if (e.code == 'invalid-verification-id') {
        print('Invalid verification ID!');
      }
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('example-firebase', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,

        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 5),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),

            SizedBox(height: 5),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),

            ElevatedButton(onPressed: createUser, child: Text('CreateUser')),
            ElevatedButton(onPressed: () => login(false), child: Text('Login')),
            ElevatedButton(onPressed: deleteUser, child: Text('DeleteUser')),
          ],
        ),
      ),
    );
  }
}
