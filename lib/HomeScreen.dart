import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Is that tone?'),
      ),
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: ElevatedButton(
              child: Center(child: Text('Start')),
              onPressed: () {
                Navigator.pushNamed(context, '/gameCard');
              },
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
