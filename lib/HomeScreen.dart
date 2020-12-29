import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<bool> onTapped;
  HomeScreen({this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: ElevatedButton(
              child: Center(child: Text('Start')),
              onPressed: () => onTapped(true),
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
