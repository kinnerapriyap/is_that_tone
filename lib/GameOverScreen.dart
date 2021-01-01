import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_that_tone/ToneAppState.dart';

class GameOverScreen extends StatefulWidget {
  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
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
          List<dynamic> players = snapshot.data['uids'];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: players.map((uid) {
                    int score = List.generate(appState.maxRounds, (i) => i + 1)
                        .map((round) =>
                            snapshot.data[round.toString()][uid] ==
                            snapshot.data[round.toString()][players[round - 1]])
                        .where((e) => e == true)
                        .length;
                    return _tile(uid, score, appState.isActivePlayer);
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    child: Center(child: Text('Finish game')),
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tile(String uid, int score, bool isActivePlayer) {
    return Center(
      child: Text(
        uid + ": " + score.toString(),
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
