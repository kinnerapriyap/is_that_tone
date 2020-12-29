import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameCardScreen extends StatefulWidget {
  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCardScreen> {
  int _activeRound;

  Future<void> setFinalAnswer(String finalAnswer) {
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc('BearClaw')
        .update({
          "$uid.$_activeRound": finalAnswer,
          //"activeRound": _activeRound + 1,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  _selectAnswer(String wordId) async {
    final result =
        await Navigator.pushNamed(context, '/wordCard', arguments: wordId);
    await setFinalAnswer(result);
    Navigator.pushNamed(context, '/roundOver');
  }

  String nextAnswer(currentAnswer) {
    ListQueue<String> allowedAnswers = ListQueue.of(List<String>.generate(
            8, (i) => String.fromCharCode('A'.codeUnitAt(0) + i))
        .where((value) => value != null));
    var iterator = allowedAnswers.iterator;
    while (iterator.current != currentAnswer) {
      iterator.moveNext();
    }
    iterator.moveNext();
    return iterator.current;
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
              'Word: ',
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

  Widget _buildGrid() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc('BearClaw')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          childAspectRatio: 1,
          padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
          children: snapshot
              .data[FirebaseAuth.instance.currentUser.uid.toString()].entries
              .map<Widget>((e) {
            _activeRound = int.parse(snapshot.data['activeRound'].toString());
            return _tile(e, snapshot.data['wordIds'][_activeRound - 1]);
          }).toList(),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        );
      });

  Widget _tile(MapEntry entry, String wordId) {
    var bgColor;
    var isDisabled = true;
    bool noEntry = entry.value == "";
    if (_activeRound == int.parse(entry.key)) {
      bgColor = Colors.green[50];
      isDisabled = false;
    } else if (noEntry) {
      bgColor = Colors.grey;
    } else {
      bgColor = Colors.green[100];
    }
    return ElevatedButton(
        child: Center(child: Text(noEntry ? entry.key : entry.value)),
        onPressed: isDisabled ? null : () => _selectAnswer(wordId),
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: bgColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ));
  }
}
