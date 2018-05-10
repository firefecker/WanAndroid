import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/home.dart';
import 'package:flutter_app/app/model/second.dart';
import 'package:flutter_app/app/model/third.dart';

class BossApp extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<BossApp>{

  int _currentIndex = 0;
  List<Widget> children ;

  @override
  void initState() {
    super.initState();
    children = <Widget>[new MyApp1(), new MyApp3(), new MyApp2(), new MyApp3()];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("主页"),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.adjust),
              title: new Text("整理"),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.map),
              title: new Text("地图"),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.face,),
              title: new Text("我的"),
              backgroundColor: Colors.white)
        ],
      ),
    );
  }
}
