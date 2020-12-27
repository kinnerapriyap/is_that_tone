import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';

class GameCard extends StatefulWidget {
  GameCard({Key key, @required this.activeRound}) : super(key: key);

  final int activeRound;

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  LinkedHashMap<int, String> _rounds = LinkedHashMap();

  @override
  void initState() {
    super.initState();
    _loadRounds();
  }

  _loadRounds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rounds = LinkedHashMap.fromIterable(List<int>.generate(8, (i) => i + 1),
          key: (item) => item,
          value: (item) => prefs.getString(item.toString()) ?? null);
    });
  }

  _applyAnswer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.activeRound.toString(), _rounds[widget.activeRound]);
  }

  _setNextAnswer() {
    String _nextAnswer = nextAnswer(_rounds[widget.activeRound]);
    setState(() {
      _rounds[widget.activeRound] = _nextAnswer ?? 'A';
    });
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
      appBar: AppBar(
        title: Text('Is that tone?'),
      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _applyAnswer(),
        label: Text('Apply'),
        icon: Icon(Icons.check_sharp),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildGrid() => GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 50,
        crossAxisSpacing: 50,
        childAspectRatio: 1,
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
        children: _rounds.entries.map<Widget>((e) => _tile(e)).toList(),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      );

  Widget _tile(MapEntry entry) {
    var bgColor;
    var isDisabled = true;
    if (widget.activeRound == entry.key) {
      bgColor = Colors.green[50];
      isDisabled = false;
    } else if (entry.value == null) {
      bgColor = Colors.grey;
    } else {
      bgColor = Colors.green[100];
    }
    return ElevatedButton(
        child: Center(child: Text(entry.value ?? entry.key.toString())),
        onPressed: isDisabled ? null : () => _setNextAnswer(),
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: bgColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ));
  }
}
