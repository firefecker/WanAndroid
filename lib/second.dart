import 'package:flutter/material.dart';

class MyApp2 extends Scaffold {
  final List<Widget> title;

  MyApp2(this.title);

  @override
  PreferredSizeWidget get appBar => new AppBar(title: new Text("Saved Suggestions"));

  @override
  Widget get body => new ListView(children: title);

}