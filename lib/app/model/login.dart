import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginAndRegister extends StatefulWidget {
  bool status;

  LoginAndRegister({Key key, this.status}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      new LoginAndRegisterState(status: this.status);
}

class LoginAndRegisterState extends State<LoginAndRegister> {
  bool status;
  String title = "";
  String userName = "";
  String password = "";
  String repeatPassword = "";
  TextField TfUserName, TfPassword,TfRepeatPassword;

  LoginAndRegisterState({Key key, this.status}) {
    if (status) {
      title = "用户注册";
    } else {
      title = "用户登录";
    }
    TfUserName = new TextField(
      decoration: new InputDecoration(labelText: "用户名", hintText: "请输入用户名"),
      maxLines: 1,
      onChanged: (String value) {
        setState(() {
          userName = value;
        });
      },
      onSubmitted: (String value) {
        setState(() {
          userName = value;
        });
      },
    );
    TfPassword = new TextField(
      decoration: new InputDecoration(labelText: "密码", hintText: "请输入密码"),
      maxLines: 1,
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          password = value;
        });
      },
      onSubmitted: (String value) {
        setState(() {
          password = value;
        });
      },
    );
    TfRepeatPassword = new TextField(
      decoration:
      new InputDecoration(labelText: "确认密码", hintText: "请再次输入密码"),
      maxLines: 1,
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          repeatPassword = value;
        });
      },
      onSubmitted: (String value) {
        setState(() {
          repeatPassword = value;
        });
      },
    );
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
            TfUserName,
            TfPassword,
            TfRepeatPassword,
            new Container(
              child: new RawMaterialButton(
                  elevation: 3.0,
                  fillColor: Colors.blue,
                  highlightColor: Colors.lightBlue,
                  highlightElevation: 8.0,
                  disabledElevation: 0.0,
                  padding: const EdgeInsets.all(7.0),
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: 40.0),
                  child: new Text(
                    "注 册",
                    style: new TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                  onPressed: () {
                    _register();
                  }),
              margin: const EdgeInsets.only(top: 20.0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            TfUserName,
            TfPassword,
            new Container(
              child: new RawMaterialButton(
                  elevation: 3.0,
                  fillColor: Colors.blue,
                  highlightColor: Colors.lightBlue,
                  highlightElevation: 8.0,
                  disabledElevation: 0.0,
                  padding: const EdgeInsets.all(7.0),
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: 40.0),
                  child: new Text(
                    "登 录",
                    style: new TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                  onPressed: () {
                    _login();
                  }),
              margin: const EdgeInsets.only(top: 20.0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
      );
    }
  }

  void _register() {
    if (userName.length == 0) {
      Fluttertoast.showToast(
          msg: "用户名不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
      return;
    }
    if (password.length == 0) {
      Fluttertoast.showToast(
          msg: "密码不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
      return;
    }
    if (repeatPassword.length == 0) {
      Fluttertoast.showToast(
          msg: "重复密码不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
      return;
    }
    if (repeatPassword != password) {
      Fluttertoast.showToast(
          msg: "两次输入密码不同",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
      return;
    }

    _registerHttp();
  }

  _registerHttp() async {
    Map<String,String> map = new Map();
    var httpClient = new HttpClient();
    var uri = new Uri.http('www.wanandroid.com', '/user/register',);
//    uri.queryParameters = map;
//    {'username': userName, 'password': password, 'repassword': repeatPassword};
    var request = await httpClient.postUrl(uri);
    var response = await request.close();
    var json = await response.transform(UTF8.decoder).join();
    print(json);
  }

  void _login() {
    if (userName.length == 0) {
      Fluttertoast.showToast(
          msg: "用户名不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
      return;
    }
    if (password.length == 0) {
      Fluttertoast.showToast(
          msg: "密码不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
      return;
    }
    _loginHttp();

  }

  _loginHttp() async {

    var httpClient = new HttpClient();
//    var uri = new Uri.http('www.wanandroid.com', '/user/login', {'username': userName, 'password': password});
    var uri = new Uri(scheme: 'http',host: 'www.wanandroid.com',path: '/user/login',queryParameters: {'username': userName, 'password': password});
    var request = await httpClient.postUrl(uri);
    var response = await request.close();
    var json = await response.transform(UTF8.decoder).join();
    print(uri.toString());
  }
}
