import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mine extends StatelessWidget {
  Widget widget;

  Mine() {
    widget = new MineStateless();
  }

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class MineStateless extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MineState();
  }
}

class MineState extends State<MineStateless> {
  SharedPreferences prefs;
  String userData = "";

  MineState() {
    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Card(
          child: _getLoginWidget(userData),
          elevation: 2.0,
          margin: const EdgeInsets.only(top: 16.0, bottom: 6.0),
        )
      ],
    );
  }

  _incrementCounter() async {
    prefs = await SharedPreferences.getInstance();
    userData = prefs.getString('userData');
//    await prefs.setInt('counter', counter);
    setState(() {});
  }

  Widget _getLoginWidget(String userData) {
    if (userData == null || userData.length == 0) {
      return new InkWell(
        child: new Container(
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.person_outline,
                color: Colors.blue,
                size: 50.0,
              ),
              new Text("请注册或者登录",style: new TextStyle(fontSize: 20.0),),
            ],
          ),
          padding: const EdgeInsets.only(top: 10.0,left: 10.0,bottom: 10.0),
        ),
        onTap: _loginNotify,
      );
    }
  }

  void _loginNotify() {
    _neverSatisfied();
  }

  Future<Null> _neverSatisfied() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('提示'),

          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('请选择相关选项。'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('注册'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (ctx) =>
                    new LoginAndRegister(status: true)));
              },
            ),
            new FlatButton(
              child: new Text('登录'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (ctx) =>
                    new LoginAndRegister(status: false)));
              },
            ),
          ],
        );
      },
    );
  }
}


