import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/entity/tree.dart';
import 'package:flutter_app/app/model/dash_detail.dart';
import 'package:flutter_app/home.dart';

int status = 0;
List<Data> list = new List();

class DashBoard extends StatelessWidget {
  Widget widget;

  DashBoard() {
    widget = new DashBoardStateless();
  }

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class DashBoardStateless extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new DashBoardState();
  }
}

class DashBoardState extends State<DashBoardStateless> {

  @override
  Widget build(BuildContext context) {
    if (list.length == 0) {
      _getDashBoard();
    }
    return _buildHome();
  }

  void _getDashBoard() async {
    try {
      var httpClient = new HttpClient();
      var uri = Uri.parse(BaseURL + "/tree/json");
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        status = 0;
        var json = await response.transform(UTF8.decoder).join();
        list = DashEntity.fromJson(json);
      } else {
        status = -1;
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
      if (list.length != 0) {
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
        child: new ListView.builder(
            itemCount: list.length,
            physics: new AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return new InkWell(
                child: new Card(
                  elevation: 6.0,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: new Text(list[index].name, style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),),
                        margin: const EdgeInsets.all(10.0),
                      ),
                      new Wrap(
                        children: _getItems(list[index].children),)
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (ctx) =>
                          new DashDetail(data: list[index],)
//                      new NewsDetail(id: "http://www.baidu.com")
                  ));
                },
              );
            }),
        onRefresh: () {
          list.clear();
          setState(() {});
          _getDashBoard();
        });
  }

  List<Widget> _getItems(List<Children> children) {
    List<Widget> widgets = new List();
    for (var i = 0; i < children.length; i ++) {
      widgets.add(new Container(
        child: new Text(children[i].name, style: new TextStyle(
            fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w400),),
        margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),),
      );
    }
    return widgets;
  }
}
