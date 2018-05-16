import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/entity/user.dart';
import 'package:flutter_app/app/model/collect.dart';
import 'package:flutter_app/app/model/login.dart';
import 'package:flutter_app/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minibus/minibus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

MiniBus eventbus = new MiniBus();

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
  UserEntity entity;

  MineState() {
    _incrementCounter();
    eventbus.subscribe(BaseURL, () {
      _fromJsonUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Card(
          child: _getLoginWidget(userData),
          elevation: 2.0,
          margin: const EdgeInsets.only(top: 16.0, bottom: 6.0),
        ),
        new Card(
          child: new InkWell(
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new Expanded(child: new Text("我的收藏")),
                  new Icon(Icons.navigate_next),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15.0, left: 10.0), color: Colors.white,),
            onTap: () {
              if (userData == null || userData.length == 0) {
                _neverSatisfied();
              } else {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (ctx) =>
                    new Collection(entity)));
              }
            },
          ),
          elevation: 0.5,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, side: BorderSide.none),
          margin: const EdgeInsets.all(0.0),
        ),
        new Card(
          child: new InkWell(
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new Expanded(child: new Text("关于")),
                  new Icon(Icons.navigate_next),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15.0, left: 10.0),
              color: Colors.white,),
            onTap: () {
              _launchURL();
            },),
          margin: const EdgeInsets.only(top: 5.0),
          elevation: 0.5,
        ),
      ],
    );
  }

  _incrementCounter() async {
    prefs = await SharedPreferences.getInstance();
    _fromJsonUser();
  }

  void _fromJsonUser() {
    userData = prefs.getString('userData');
    if (userData != null && userData.length != 0) {
      entity = UserEntity.fromJson(userData);
      if (entity.data == null) {
        userData = "";
      }
    }
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
              new Text("请注册或者登录", style: new TextStyle(fontSize: 20.0),),
            ],
          ),
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        ),
        onTap: _loginNotify,
      );
    } else {
      var email = entity.data.email == null ||
          entity.data.email.length == 0 ? "没有绑定邮箱" : entity.data.email;
      return new InkWell(
        child: new Container(
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.person_outline,
                color: Colors.blue,
                size: 50.0,
              ),
              new Column(
                children: <Widget>[
                  new Text("用户名：" + entity.data.username,
                    style: new TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.ltr,),
                  new Text("邮    箱：" + email,
                    style: new TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.ltr,),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        ),
        onTap: _loginNotify,
      );
    }
  }

  void _loginNotify() {
    if (userData == null || userData.length == 0) {
      _neverSatisfied();
    } else {
      _neverSatisfied1();
    }
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

  Future<Null> _neverSatisfied1() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('提示'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('确定退出登录?'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                prefs.setString("userData", "").then((value) {
                  _fromJsonUser();
                });
              },
            ),
            new FlatButton(
              child: new Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL() async {
    const url = 'https://github.com/firefecker/flutter_app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: 'Could not launch $url',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
    }
  }
}


