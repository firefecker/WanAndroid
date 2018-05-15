import 'package:flutter/material.dart';


class LoginAndRegister extends StatefulWidget {

  bool status;

  LoginAndRegister({Key key, this.status}) :super(key: key);

  @override
  State<StatefulWidget> createState() => new LoginAndRegisterState(status: this.status);
}

class LoginAndRegisterState extends State<LoginAndRegister> {

  bool status;
  String title = "";

  LoginAndRegisterState({Key key, this.status}) {
    if (status) {
      title = "用户注册";
    } else {
      title = "用户登录";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        centerTitle: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            tooltip: "backPressed",
            onPressed: _popSaved),
      ),
      body: _getContainer(status),
    );
  }

  void _popSaved() {
    Navigator.of(context).pop("");
  }

  Widget _getContainer(bool status) {
    if (status) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: "用户名",hintText: "请输入用户名"),
              maxLines: 1,
            ),
            new TextField(
              decoration: new InputDecoration(labelText: "密码",hintText: "请输入密码"),
              maxLines: 1,
              obscureText: true,
            )
          ],
        ),
        padding: const EdgeInsets.all(10.0),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: "用户名",hintText: "请输入用户名"),
              maxLines: 1,
            ),
            new TextField(
              decoration: new InputDecoration(labelText: "密码",hintText: "请输入密码"),
              maxLines: 1,
              obscureText: true,
            )
          ],
        ),
        padding: const EdgeInsets.all(10.0),
      );
    }
  }
}