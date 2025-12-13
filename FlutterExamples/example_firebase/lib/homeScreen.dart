import 'package:example_firebase/SignInScreen.dart';
import 'package:example_firebase/changeInfos.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:example_firebase/changeInfos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth? auth;

  String? mail = "";
  String? uid = "";
  bool showProfile = false;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    super.initState();
  }
  
  Future<void> logout() async {
    await auth!.signOut();
    setState(() {});
  }

  Future<void> fetchProfile() async {
    try {
      mail = auth
          ?.currentUser
          ?.email; // eğer auth null değilse devam et, null ise iptal et ve null döndür demek, mail ise string olabilir ya da olmayabilir
      uid = auth?.currentUser?.uid;
    } catch (e) {
      print('Something went wrong!');
    }

    setState(() {
      showProfile = !showProfile;
    }); // Flutter'da arayüzü tekrar çizmek için setState() çağırman gerekiyor
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('example-firebase', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,

        leading: IconButton(
          onPressed: () {
            logout();
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SignInScreen(),
              ),
            );
          },
          icon: Icon(Icons.back_hand),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 5),

            if (showProfile) ...[
              Text('Infos:'),
              ListTile(title: Text(mail!), subtitle: Text(uid!)),
            ],

            /// ...[] widget listelerini dinamik olarak eklemek için kullanılır
            ElevatedButton(onPressed: logout, child: Text('Logout')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const Changeinfos(),
                  ),
                );
              },
              child: Text('ChangePassword'),
            ),
            ElevatedButton(
              onPressed: fetchProfile,
              child: Text('FetchProfile'),
            ),
          ],
        ),
      ),
    );
  }
}
