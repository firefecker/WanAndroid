import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/newsdetail.dart';
import 'package:flutter_app/app/entity/hot_key.dart';
import 'package:flutter_app/home.dart';

int status = 0;
List<Data> hotEntities = new List();
List<Data> friendEntities = new List();

class Hotkey extends StatelessWidget {
  Widget widget;

  Hotkey() {
    widget = new HotkeyStateless();
  }

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class HotkeyStateless extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DashBoardState();
  }
}

class DashBoardState extends State<HotkeyStateless> {
  @override
  Widget build(BuildContext context) {
    if (hotEntities.length == 0 || friendEntities.length == 0) {
      _getHotkey();
    }
    return _buildHome();
  }

  void _getHotkey() async {
    try {
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(
          Uri.parse(BaseURL + "/hotkey/json"));
      var response = await request.close();
      var request1 = await httpClient.getUrl(
          Uri.parse(BaseURL + "/friend/json"));
      var response1 = await request1.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        hotEntities.addAll(HotEntity.fromJson(json));
        status = 0;
        if (response.statusCode == HttpStatus.OK) {
          var json1 = await response1.transform(UTF8.decoder).join();
          friendEntities.addAll(HotEntity.fromJson(json1));
        }
      } else {
        if (response.statusCode == HttpStatus.OK) {
          status = 0;
          var json1 = await response1.transform(UTF8.decoder).join();
          friendEntities.addAll(HotEntity.fromJson(json1));
        } else {
          status = -1;
        }
      }
    } catch (exception) {
      print(exception.toString());
      status = -1;
    } finally {
      setState(() {});
    }
  }

  Widget _buildHome() {
    return getCurrentStateWidget();
  }

  Widget getCurrentStateWidget() {
    Widget currentStateWidget;
    if (status == -1) {
      currentStateWidget = _getErrorState();
    } else {
      if (hotEntities.length != 0 || friendEntities.length != 0) {
        currentStateWidget = _getSuccessStateWidget();
      } else {
        currentStateWidget = _getLoadingStateWidget();
      }
    }
    return currentStateWidget;
  }

  Widget _getErrorState() {
    return new Center(
      child: new Row(),
    );
  }

  Widget _getLoadingStateWidget() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget _getSuccessStateWidget() {
    return new RefreshIndicator(
      child: new ListView(
        children: <Widget>[
          new Container(
            child: new Text("搜索热词", style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),),
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
          ),
          new Wrap(
            children: _getWidgets(hotEntities,false),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: new Text("常用网站", style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),),
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
          ),
          new Wrap(
            children: _getWidgets(friendEntities,true),
          ),
        ],
      ),
      onRefresh: () {
        hotEntities.clear();
        friendEntities.clear();
        setState(() { _getHotkey();});
      },
    );
  }

  List<Widget> _getWidgets(List<Data> hotEntities, bool isNet) {
    List<Widget> widgets = [];
    for (var i = 0; i < hotEntities.length; i ++) {
      widgets.add(new Container(
          margin: const EdgeInsets.only(top: 10.0,left: 6.0,bottom: 5.0),
          child: new InkWell(
            child: new Chip(
              backgroundColor: Colors.white,
              label: new Text(hotEntities[i].name,
                style: new TextStyle(fontSize: 16.0),),
            ),
            onTap: () {
              if (isNet) {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (ctx) => new NewsDetail(id: hotEntities[i].link)));
              } else {
                
              }
            },
          )
      ));
    }
    return widgets;
  }
}