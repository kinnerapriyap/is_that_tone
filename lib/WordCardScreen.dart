import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final String wordId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Word: $wordId'),
            _buildList(wordId),
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

  Widget _buildList(String wordId) => FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('wordCards').doc(wordId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        Map<String, dynamic> data = snapshot.data.data();
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: data.entries.map<Widget>((e) => _tile(e)).toList(),
        );
      });

  RadioListTile _tile(MapEntry entry) => RadioListTile(
        value: entry.key,
        groupValue: _answer,
        onChanged: (i) {
          setState(() {
            _answer = entry.key;
          });
        },
        title: Center(
            child: Text(entry.key + " " + entry.value,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))),
      );
}
