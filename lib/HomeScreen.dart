import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_that_tone/ToneAppState.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller;

  Future<String> _registerUser() async {
    User currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user.uid;
    }
  }

  _createRound(String uid, String room, int maxRounds) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('rooms').doc(room);
    Map<String, dynamic> initialValues = {
      "activeRound": 1,
      "wordIds": ["edo", "sare"],
      "uids": [uid],
    };
    initialValues.addEntries(List.generate(maxRounds, (i) => i + 1)
        .map((e) => MapEntry(e.toString(), {})));
    ref.get().then((docSnapshot) => {
          if (docSnapshot.exists)
            _joinRound(uid, room)
          else
            ref.set(initialValues)
        });
  }

  _joinRound(String uid, String room) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction
          .get(FirebaseFirestore.instance.collection('rooms').doc(room));
      List<dynamic> players = freshSnap.data()['uids'];
      if (!players.contains(uid)) players.add(uid);
      transaction.update(freshSnap.reference, {
        "uids": players,
      });
    });
  }

  _start() async {
    String uid = await _registerUser();
    ToneAppState appState = Provider.of<ToneAppState>(context, listen: false);
    appState.room = _controller.text.trim();
    _createRound(uid, appState.room, appState.maxRounds);
    Navigator.pushNamed(context, '/gameCard');
  }

  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Is that tone?'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter a room name'),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 200,
              child: ElevatedButton(
                  child: Center(child: Text('Join game')),
                  onPressed: () => _start(),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
