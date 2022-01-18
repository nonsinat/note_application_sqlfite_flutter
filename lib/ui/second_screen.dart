import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  final String? payload;
  const SecondScreen({
    Key? key,
    this.payload,
  }) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.payload.toString()),
      ),
    );
  }
}
