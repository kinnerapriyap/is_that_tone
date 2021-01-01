import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ToneAppState.dart';
import 'package:provider/provider.dart';

class RoundOverScreen extends StatelessWidget {
  final ValueChanged<bool> onTapped;
  RoundOverScreen({this.onTapped});

  Future<Map<String, dynamic>> _getWordCard(List<String> usedWords) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('wordCards')
        .where('word', whereNotIn: usedWords)
        .limit(1)
        .get();
    return result.docs[0].data();
  }

  Future<void> _incrementRound(BuildContext context) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      String _room = Provider.of<ToneAppState>(context, listen: false).room;
      DocumentSnapshot freshSnap = await transaction
          .get(FirebaseFirestore.instance.collection('rooms').doc(_room));
      int newRound = freshSnap['activeRound'] + 1;
      List<String> usedWords = [];
      freshSnap['wordCards'].forEach((key, value) {
        usedWords.add(value['word']);
      });
      Map newWordCard = await _getWordCard(usedWords);
      transaction.update(freshSnap.reference, {
        "activeRound": newRound,
        "wordCards.$newRound": newWordCard,
      });
    });
  }

  _goToNext(BuildContext context) async {
    bool isActivePlayer =
        Provider.of<ToneAppState>(context, listen: false).isActivePlayer;
    if (isActivePlayer) {
      await _incrementRound(context);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: ElevatedButton(
              child: Center(child: Text('Next round')),
              onPressed: () => _goToNext(context),
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
