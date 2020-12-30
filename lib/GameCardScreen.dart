import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameCardScreen extends StatefulWidget {
  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCardScreen> {
  int _activeRound;
  String _uid;

  Future<void> setFinalAnswer(String finalAnswer) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc('BearClaw')
        .update({
          "$_activeRound.$_uid": finalAnswer,
          //"activeRound": _activeRound + 1,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  _selectAnswer(String wordId) async {
    final finalAnswer =
        await Navigator.pushNamed(context, '/wordCard', arguments: wordId);
    if (finalAnswer == null) return;
    await setFinalAnswer(finalAnswer);
    Navigator.pushNamed(context, '/roundOver');
  }

  @override
  void initState() {
    _uid = FirebaseAuth.instance.currentUser.uid.toString();
    super.initState();
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
          children: List.generate(2, (i) => i + 1).map((round) {
            _activeRound = int.parse(snapshot.data['activeRound'].toString());
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

  Widget _tile(int round, String value, String wordId) {
    var bgColor;
    var isDisabled = true;
    bool noEntry = value == "";
    if (_activeRound == round) {
      bgColor = Colors.green[50];
      isDisabled = false;
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
