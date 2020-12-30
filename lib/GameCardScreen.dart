import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:is_that_tone/ToneAppState.dart';
import 'package:provider/provider.dart';

class GameCardScreen extends StatefulWidget {
  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCardScreen> {
  StreamSubscription<DocumentSnapshot> streamSub;
  int _activeRound;
  String _uid;
  String _room;

  Future<void> setFinalAnswer(String finalAnswer) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction
          .get(FirebaseFirestore.instance.collection('rooms').doc(_room));
      transaction.update(freshSnap.reference, {
        "$_activeRound.$_uid": finalAnswer,
      });
    });
  }

  _selectAnswer(String wordId) async {
    final finalAnswer =
        await Navigator.pushNamed(context, '/wordCard', arguments: wordId);
    if (finalAnswer == null) return;
    await setFinalAnswer(finalAnswer);
  }

  Future<void> _incrementRound() {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction
          .get(FirebaseFirestore.instance.collection('rooms').doc(_room));
      transaction.update(freshSnap.reference, {
        "activeRound": freshSnap['activeRound'] + 1,
      });
    });
  }

  _listenRoom() async {
    Stream<DocumentSnapshot> roomSnapshot =
        FirebaseFirestore.instance.collection('rooms').doc(_room).snapshots();
    ToneAppState appState = Provider.of<ToneAppState>(context, listen: false);
    streamSub = roomSnapshot.listen((snapshot) async {
      _activeRound = int.parse(snapshot.data()['activeRound'].toString());
      Map<String, dynamic> roundAnswers =
          snapshot.data()[_activeRound.toString()];
      List<dynamic> players = snapshot.data()['uids'];
      bool isRoundOver =
          roundAnswers.length == players.length && players.isNotEmpty;
      if (isRoundOver && this.mounted) {
        if (_activeRound >= appState.maxRounds)
          // TODO: Game over!
          Navigator.pop(context);
        else if (FirebaseAuth.instance.currentUser.uid == players[0]) {
          await _incrementRound();
        }
        Navigator.pushNamed(context, '/roundOver');
      }
    });
  }

  @override
  void initState() {
    _uid = FirebaseAuth.instance.currentUser.uid.toString();
    _room = Provider.of<ToneAppState>(context, listen: false).room;
    _listenRoom();
    super.initState();
  }

  @override
  void dispose() {
    if (streamSub != null) streamSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'Waiting for players to answer...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() =>
      Consumer<ToneAppState>(builder: (context, appState, child) {
        if (appState.room == null) return const Text('Loading...');
        print(appState.room);
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rooms')
                .doc(appState.room.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                childAspectRatio: 1,
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                children: List.generate(appState.maxRounds, (i) => i + 1)
                    .map((round) {
                  Map<String, dynamic> currentAnswers =
                      snapshot.data[round.toString()];
                  String value = currentAnswers[_uid] ?? "";
                  return _tile(
                      round, value, snapshot.data['wordIds'][_activeRound - 1]);
                }).toList(),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
            });
      });

  Widget _tile(int round, String value, String wordId) {
    var bgColor;
    var isDisabled = true;
    bool noEntry = value == "";
    if (_activeRound == round) {
      bgColor = Colors.green[50];
      if (noEntry) isDisabled = false;
    } else if (noEntry) {
      bgColor = Colors.grey;
    } else {
      bgColor = Colors.green[100];
    }
    return ElevatedButton(
        child: Center(child: Text(noEntry ? round.toString() : value)),
        onPressed: isDisabled ? null : () => _selectAnswer(wordId),
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: bgColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ));
  }
}
