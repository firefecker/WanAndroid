import 'package:flutter/material.dart';


class HomeDetail extends StatelessWidget {

  final String title;


  HomeDetail({Key key,this.title});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Text("这是详情页"),
      ),
      bottomNavigationBar: null,
    );
  }

}