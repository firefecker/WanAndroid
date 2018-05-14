import 'package:flutter/material.dart';

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TapboxA(),
    );
  }
}

class TapboxA extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TapboxAState();
  }
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;
  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }
  Widget gestureDetector() {
    return new GestureDetector(
      onTap: _handleTap,
      child: new Container(
        child: new Center(
          child: new Text(
            _active ? 'Active' : 'Inactive',
            style: new TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: new BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Test3"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.filter_vintage), onPressed: _onPressed)],
      ),
      body: new Center(
        child: gestureDetector(),
      ),
    );
  }

  void _onPressed() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) {
          return new MyApp3();
        })
    );
  }
}