import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/entity/article.dart';
import 'package:flutter_app/app/model/newsdetail.dart';
import 'package:flutter_app/home.dart';
import 'package:http/http.dart';



class Search extends StatefulWidget {
  String content;
  Search(this.content);

  @override
  State<StatefulWidget> createState() =>
      new SearchState(this.content);
}

class SearchState extends State<Search> {

  int pageIndex = 0;
  int total = 0;
  int status = 0;
  List<Datas> articles = new List();
  ScrollController _controller = new ScrollController();
  String content;

  SearchState(this.content);

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = (_controller.position).pixels;
      if (maxScroll == pixels && articles.length < total) {
        pageIndex++;
        _getCollection(pageIndex);
      }
    });
    if (articles.length == 0) {
      pageIndex = 0;
      _getCollection(pageIndex);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("热词搜索"),
        centerTitle: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            tooltip: "backPressed",
            onPressed: _popSaved),
      ),
      body: _buildHome(),
    );
  }

  List<Datas> flateData(List<Datas> datas) {
    List<Datas> list = [];
    for (var i = 0; i < datas.length; i ++) {
      bool notContain = true;
      for (var j = 0; j < articles.length; j ++) {
        if (articles[j].id == datas[i].id) {
          notContain = false;
        }
      }
      if (notContain) {
        list.add(datas[i]);
      }
    }
    return list;
  }

  Widget _buildHome() {
    return getCurrentStateWidget();
  }

  Widget getCurrentStateWidget() {
    Widget currentStateWidget;
    if (status == -1) {
      currentStateWidget = _getErrorState();
    } else {
      if (articles.length != 0) {
        currentStateWidget = _getSuccessStateWidget();
      } else {
        currentStateWidget = _getLoadingStateWidget();
      }
    }
    return currentStateWidget;
  }

  Widget _getSuccessStateWidget() {
    return new RefreshIndicator(
      child: new ListView.builder(
          itemCount: articles.length ,
          physics: new AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: _controller,
          itemBuilder: (context, index) {
            return new InkWell(
              onTap: () {
                // 点击跳转到详情
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (ctx) => new NewsDetail(id: articles[index].link)
                ));
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(articles[index].title,
                      style: new TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  new Row(
                    children: <Widget>[
                      buildButtonRow(
                          Icons.person, articles[index].author, 10.0),
                      buildButtonRow(
                          Icons.select_all, content, 10.0),
                      Expanded(
                        child: buildButtonRow(
                            Icons.date_range, articles[index].niceDate, 5.0),
                        flex: 1,
                      ),],),
                  new Divider()
                ],
              ),
            );
          }
      ),
      onRefresh: () {
        articles.clear();
        pageIndex = 0;
        setState(() {
          _getCollection(pageIndex);
        });
      },);
  }

  Widget _getErrorState() {
    return new Center(
      child: new Row(),
    );
  }

  /**
   * 将文本和icon组合成为控件的方法
   */
  Row buildButtonRow(IconData icon, String label, double margin) {
    Color color = Theme
        .of(context)
        .primaryColor;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Container(
          child: new Icon(icon, color: color, size: 20.0,),
          margin: EdgeInsets.only(left: margin, bottom: 10.0),
          alignment: Alignment.centerRight,
        ),
        new Container(
          child: new Text(label,
            style: new TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
            ),
          ),
          margin: const EdgeInsets.only(bottom: 10.0,right: 3.0),
        ),
      ],
    );
  }

  Widget _getLoadingStateWidget() {
    return new Center(
      child: new Text("暂无数据"),
    );
  }

  void _popSaved() {
    Navigator.of(context).pop("");
  }

  void _getCollection(int index) async {
    try {
      Map<String, String> params = new Map();
      params['k'] = content;
      var request = new MultipartRequest(
          'POST', Uri.parse(BaseURL + "/article/query/$pageIndex/json"));
      request.fields.addAll(params);

      var response = await request.send();
      if (response.statusCode == HttpStatus.OK) {
        status = 0;
        var json = await response.stream.transform(UTF8.decoder).join();
        var fromJson = ArticleEntity
            .fromJson(json)
            .data;
        total = fromJson.total;
        articles.addAll(flateData(fromJson.datas));
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
}