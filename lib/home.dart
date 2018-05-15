import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/app_second.dart';
import 'package:flutter_app/app/model/dash_board.dart';
import 'package:flutter_app/app/model/home.dart';

const String BaseURL = "http://www.wanandroid.com";

class BossApp extends StatefulWidget {

  List<Widget> children;
  @override
  HomeState createState() => new HomeState(children);

  BossApp() {
    children = <Widget>[new Home(), new DashBoard(), new Home(), new DashBoard()];
  }
}

class HomeState extends State<BossApp> {

  int _currentIndex = 0;
  List<Widget> children;
  String title = "首页";

  HomeState(this.children);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add_alarm, color: Colors.white),
              tooltip: "Add Alarm",
              onPressed: _pushSaved),
          new PopupMenuButton<String>(
            icon: new Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: "price", child: new Text('Sort by price')),
              new PopupMenuItem<String>(
                  value: "time", child: new Text('Sort by time')),
            ],
            onSelected: (String action) {
              switch (action) {
                case "price":
                  break;
                case "time":
                  break;
              }
            },)
        ],
      ),
      body: children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            setTitle(index);
          });
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("主页"),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.dashboard),
              title: new Text("体系"),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.hot_tub),
              title: new Text("热词"),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.face,),
              title: new Text("我的"),
              backgroundColor: Colors.white)
        ],
      ),
    );
  }

  void setTitle(int index) {
     _currentIndex = index;
    switch (_currentIndex) {
      case 0:
        title = "首页";
        break;
      case 1:
        title = "体系";
        break;
      case 2:
        title = "热词";
        break;
      case 3:
        title = "我的";
        break;
    }
  }

  void _pushSaved() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) {
          return new MyApp2();
        })
    );
  }
}
