import 'package:flutter/material.dart';

class RoundOverScreen extends StatelessWidget {
  final ValueChanged<bool> onTapped;
  RoundOverScreen({this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: ElevatedButton(
              child: Center(child: Text('Next round')),
              onPressed: () {
                Navigator.pop(context);
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
