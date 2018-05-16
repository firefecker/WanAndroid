import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/entity/user.dart';
import 'package:flutter_app/app/model/mine.dart';
import 'package:flutter_app/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  String userName = "",
      password = "",
      repeatPassword = "";
  TextField TfUserName, TfPassword, TfRepeatPassword;
  SharedPreferences prefs;
  String userData = "";

  LoginAndRegisterState({Key key, this.status}) {
    _incrementCounter();
    if (status) {
      title = "用户注册";
    } else {
      title = "用户登录";
    }
    TfUserName = new TextField(
      decoration: new InputDecoration(labelText: "用户名", hintText: "请输入用户名"),
      maxLines: 1,
      autofocus: true,
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
      autofocus: true,
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
      autofocus: true,
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

  _incrementCounter() async {
    prefs = await SharedPreferences.getInstance();
    userData = prefs.getString('userData');
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
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width,
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

  _registerHttp(){
    Map<String, String> params = new Map();
    params['username'] = userName;
    params['password'] = password;
    params['repassword'] = repeatPassword;
    var request = new MultipartRequest(
        'POST', Uri.parse(BaseURL + "/user/register"));
    request.fields.addAll(params);
    _controlData(request);
  }

  _controlData(MultipartRequest request) async {
    var response = await request.send();
    if (response.statusCode == 200) {
      var json = await response.stream.transform(UTF8.decoder).join();
      UserEntity userEntity = UserEntity.fromJson(json);
      if (userEntity.data == null) {
        Fluttertoast.showToast(msg: userEntity.errorMsg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1);
        return;
      }
      setState(() {
        prefs.setString('userData', json);
        eventbus.post(BaseURL);
        Navigator.of(context).pop("");
      });
    } else {
      Fluttertoast.showToast(msg: "请求失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1);
    }
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
    Map<String, String> params = new Map();
    params['username'] = userName;
    params['password'] = password;
    var request = new MultipartRequest(
        'POST', Uri.parse(BaseURL + "/user/login"));
    request.fields.addAll(params);
    _controlData(request);
  }
}
