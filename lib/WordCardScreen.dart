import 'package:flutter/material.dart';
import 'const.dart';

class WordArguments {
  final Map<String, dynamic> wordCardMap;
  // word : answer
  final Map<int, String> used;

  WordArguments(this.wordCardMap, this.used);
}

class WordCardScreen extends StatefulWidget {
  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCardScreen> {
  int _result;

  _applyAnswer() {
    Navigator.pop(context, _result);
  }

  @override
  Widget build(BuildContext context) {
    final WordArguments args = ModalRoute.of(context).settings.arguments;
    List<dynamic> answers = args.wordCardMap['answers'];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Word: ${args.wordCardMap['word']}'),
            answers == null
                ? const Text('Loading...')
                : ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: answers
                        .mapIndex<Widget>(
                            (e, i) => _tile(e, i, args.used.keys.contains(e)))
                        .toList(),
                  ),
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

  RadioListTile _tile(String answer, int index, bool isUsed) => RadioListTile(
        value: index,
        groupValue: _result,
        onChanged: isUsed
            ? null
            : (i) {
                setState(() {
                  _result = index;
                });
              },
        title: Center(
            child: Text(answer,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  decoration: isUsed ? TextDecoration.lineThrough : null,
                ))),
      );
}
