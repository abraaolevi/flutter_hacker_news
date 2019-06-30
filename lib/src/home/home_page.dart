import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"),
      ),
      body: ListView(children: <Widget>[
        ListTile(title: Text("Test"), subtitle: Text("Subtitle"),trailing: Icon(Icons.launch),),
        ListTile(title: Text("Test"), subtitle: Text("Subtitle"),trailing: Icon(Icons.launch),),
        ListTile(title: Text("Test"), subtitle: Text("Subtitle"),trailing: Icon(Icons.launch),),
        ListTile(title: Text("Test"), subtitle: Text("Subtitle"),trailing: Icon(Icons.launch),),
      ],),
    );
  }
}
