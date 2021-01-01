import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:is_that_tone/ToneAppState.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  StreamSubscription<DocumentSnapshot> streamSub;

  Future<void> _setMaxRounds() async {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      ToneAppState appState = Provider.of<ToneAppState>(context, listen: false);
      DocumentSnapshot freshSnap = await transaction.get(
          FirebaseFirestore.instance.collection('rooms').doc(appState.room));
      List<dynamic> players = freshSnap.data()['uids'];
      int maxRounds = players.length;
      Map<String, dynamic> updatedValues = {
        'maxRounds': maxRounds,
      };
      updatedValues.addEntries(List.generate(maxRounds, (i) => i + 1)
          .map((e) => MapEntry(e.toString(), {})));
      transaction.update(freshSnap.reference, updatedValues);
    });
  }

  _start() async {
    await _setMaxRounds();
  }

  _listenRoom() async {
    ToneAppState appState = Provider.of<ToneAppState>(context);
    Stream<DocumentSnapshot> roomSnapshot = FirebaseFirestore.instance
        .collection('rooms')
        .doc(appState.room)
        .snapshots();
    streamSub = roomSnapshot.listen((snapshot) async {
      if (snapshot.data()['maxRounds'] != null) {
        Navigator.pushReplacementNamed(context, '/gameCard');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listenRoom();
  }

  @override
  void dispose() {
    if (streamSub != null) streamSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToneAppState appState = Provider.of<ToneAppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Is that tone?'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(appState.room.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          String uid = FirebaseAuth.instance.currentUser.uid;
          List<dynamic> players = snapshot.data['uids'];
          bool isActivePlayer = players[0] == uid;
          return Center(
            child: Container(
              height: 50,
              width: 200,
              child: isActivePlayer == true
                  ? ElevatedButton(
                      child: Center(child: Text('Start game')),
                      onPressed: () => _start(),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.green,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ))
                  : Center(child: Text('Waiting for other players to start')),
            ),
          );
        },
      ),
    );
  }
}
