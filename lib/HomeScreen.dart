import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _start() async {
    if (FirebaseAuth.instance.currentUser == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print(userCredential.toString());
    }
    Navigator.pushNamed(context, '/gameCard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Is that tone?'),
      ),
      body: Center(
        child: Container(
          height: 50,
          width: 100,
          child: ElevatedButton(
              child: Center(child: Text('Start')),
              onPressed: () => _start(),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              )),
        ),
      ),
    );
  }
}
