import 'package:flutter/material.dart';

class WordCard {
  final String word;
  final Map<String, String> scenarios;

  WordCard(this.word, this.scenarios);
}

class WordCardScreen extends StatefulWidget {
  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Word:'),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildList() => ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          _tile('A'),
          _tile('B'),
          _tile('C'),
          _tile('D'),
        ],
      );

  ListTile _tile(String title) => ListTile(
        title: Center(
            child: Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))),
      );
}
