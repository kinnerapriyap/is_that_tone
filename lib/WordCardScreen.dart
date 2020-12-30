import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordArguments {
  final String wordId;
  final List<String> usedAnswers;

  WordArguments(this.wordId, this.usedAnswers);
}

class WordCardScreen extends StatefulWidget {
  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCardScreen> {
  String _answer;

  _applyAnswer() {
    Navigator.pop(context, _answer);
  }

  @override
  Widget build(BuildContext context) {
    final WordArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Word: ${args.wordId}'),
            _buildList(args),
            ElevatedButton(
                child: Center(child: Text('Apply')),
                onPressed: () => _applyAnswer(),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildList(WordArguments args) => FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('wordCards')
          .doc(args.wordId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        Map<String, dynamic> data = snapshot.data.data();
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: data.entries
              .map<Widget>((e) => _tile(e, args.usedAnswers.contains(e.key)))
              .toList(),
        );
      });

  RadioListTile _tile(MapEntry entry, bool isUsed) => RadioListTile(
        value: entry.key,
        groupValue: _answer,
        onChanged: isUsed
            ? null
            : (i) {
                setState(() {
                  _answer = entry.key;
                });
              },
        title: Center(
            child: Text(entry.key + " " + entry.value,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  decoration: isUsed ? TextDecoration.lineThrough : null,
                ))),
      );
}
