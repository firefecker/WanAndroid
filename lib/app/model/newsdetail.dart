import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class NewsDetail extends StatefulWidget {

  String id;

  NewsDetail({Key key, this.id}) :super(key: key);

  @override
  State<StatefulWidget> createState() => new NewsDetailState(id: this.id);
}

class NewsDetailState extends State<NewsDetail> {

  String id;
  bool loaded = false;
  String detailDataStr;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  NewsDetailState({Key key, this.id});

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件
    flutterWebViewPlugin.onStateChanged.listen((state) {
      print("state: ${state.type}");
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(
        new Text("文章详情", style: new TextStyle(color: Colors.white),));
    if (!loaded) {
      titleContent.add(new CupertinoActivityIndicator());
    }
    titleContent.add(new Container(width: 50.0));
    return new WebviewScaffold(
      url: this.id,
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            tooltip: "backPressed",
            onPressed: _popSaved),
        title: new Row(
          children: titleContent,
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.share, color: Colors.white),
              tooltip: "share",
              onPressed: _share)
        ],
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }

  void _popSaved() {
    Navigator.of(context).pop("");
  }

  void _share() {
    share("分享文章链接：$id");
  }
}