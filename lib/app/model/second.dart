import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/third.dart';

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TopLake(),
    );
  }
}

class TopLake extends StatefulWidget {
  @override
  State<TopLake> createState() {
    return new TopLakeState();
  }
}

class TopLakeState extends State<TopLake> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hello World"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: new ListView(
        children: [
          //顶部添加图片
          new Image.asset(
            'images/lake.jpg',
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),
          titleSection(),
          buttonSection(),
          textSection(),
        ],
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) {
          return new MyApp3();
        })
    );
  }

  /**
   * 将文本和icon组合成为控件的方法
   */
  Column buildButtonColumn(IconData icon, String label) {
    Color color = Theme
        .of(context)
        .primaryColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(icon, color: color,),
        new Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: new Text(label,
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        )
      ],
    );
  }

  /**
   * 按钮和文本组合的容器
   */
  Widget buttonSection() {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
          buildButtonColumn(Icons.label, 'LABEL'),
          buildButtonColumn(Icons.star, 'STAR'),
        ],
      ),
    );
  }

  /**
   * 底部的文本容器
   */
  Widget textSection() {
    return new Container(
      padding: const EdgeInsets.all(12.0),
      child: new Text(
          "    Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.",
          softWrap: true,
          style: new TextStyle(
            fontSize: 15.0,
          )
      ),
    );
  }

  /**
   * 图片下面的标题和收藏内容容器
   */
  Widget titleSection() {
    return new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Row(
        children: [new Expanded(
//          child: new Row(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [new Container(
//              padding: const EdgeInsets.only(bottom: 8.0),
//              child: new Text('Oeschinen Lake Campground',
//                style: new TextStyle(fontWeight: FontWeight.bold,),),
//            ),
//            new Text('Kandersteg, Switzerland',
//              style: new TextStyle(color: Colors.grey[500],),),
//            ],
//          ),
          //Column 垂直排列,
          // Row水平排列
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Text("Oeschinen Lake Campground",
                style: new TextStyle(fontWeight: FontWeight.bold),),
            ),
            new Text("Kandersteg, Switzerland",
              style: new TextStyle(color: Colors.grey[500]),)
            ],
          ),
        ),
        new FavoriteWidget()
        ],
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {

  @override
  _FavoriteWidgetState createState() => new _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {

  bool _isFavorited = true;
  int _favoriteCount = 100;

  void _toggleFavorite() {
    setState(() {
      // If the lake is currently favorited, unfavorite it.
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
        // Otherwise, favorite it.
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        new Container(
          padding: new EdgeInsets.all(0.0),
          child: new IconButton(
            icon: (_isFavorited
                ? new Icon(Icons.star)
                : new Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        //new Text('$_favoriteCount',style: new TextStyle(fontSize: 18.0,),),
        new SizedBox(
          width: 30.0,
          child: new Container(
            child: new Text(
              '$_favoriteCount',
              style: new TextStyle(fontSize: 16.0,),),
          ),
        ),
      ],
    );
  }

}