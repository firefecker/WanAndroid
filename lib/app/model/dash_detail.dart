import 'package:flutter/material.dart';
import 'package:flutter_app/app/entity/tree.dart';
import 'package:flutter_app/app/component/dash_list.dart';

Data dashData;

class DashDetail extends StatelessWidget {
  Widget widget;


  DashDetail({Key key, data}) {
    dashData = data;
    widget = new DashDetailStateless();
  }

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class DashDetailStateless extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DashDetailState();
  }
}

class DashDetailState extends State<DashDetailStateless> {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new DefaultTabController(
        length: dashData.children.length,
        child: new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                tooltip: "Back Arrow",
                onPressed: _popSaved),
            title: Text(dashData.name),
            centerTitle: false,
            bottom: new TabBar(
              isScrollable: true,
              tabs: dashData.children.map((Children children) {
                return new Tab(
                  text: children.name,
                );
              }).toList(),
            ),
          ),
          body: new TabBarView(children: _getTabBarView(dashData.children)),
        ),
      ),
    );
  }

  List<Widget> _getTabBarView(List<Children> children) {
    List<Widget> widgets = [];
    for (var i = 0; i < children.length; i ++) {
      widgets.add(new DashList(children[i].id));
    }
    return widgets;
  }

  void _popSaved() {
    Navigator.of(context).pop("");
  }
}