import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/newsdetail.dart';
import 'package:flutter_app/app/component/slideview.dart';
import 'package:flutter_app/app/entity/article.dart';
import 'package:flutter_app/app/entity/banner.dart';
import 'package:flutter_app/home.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new HomeStateless();
  }
}

class HomeStateless extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }

}

class HomeState extends State<HomeStateless>
    with SingleTickerProviderStateMixin {
  Map decode;
  List<Datas> articles = new List();
  List<BannerData> bannerList = new List();
  int pageIndex = 0;
  int status = 0;
  int total = 0;
  ScrollController _controller = new ScrollController();
  List<Widget> items = new List();
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = (_controller.position).pixels;
      if (maxScroll == pixels && articles.length < total) {
        pageIndex++;
        _getArticle(pageIndex);
      }
    });
    return _buildHome();
  }


  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        length: bannerList == null ? 0 : bannerList.length, vsync: this);
    pageIndex = 0;
    _getArticle(pageIndex);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  _getBanner(HttpClient httpClient) async {
    bannerList.clear();
    var uri1 = Uri.parse(
        BaseURL + "/banner/json");
    var request1 = await httpClient.getUrl(uri1);
    var response1 = await request1.close();
    if (response1.statusCode == HttpStatus.OK) {
      var json = await response1.transform(UTF8.decoder).join();
      BannerEntity entity = BannerEntity
          .fromJson(json);
      bannerList.addAll(entity.data);
    }
  }

  _getArticle(int i) async {
    try {
      var httpClient = new HttpClient();
      var uri = Uri.parse(
          BaseURL + "/article/list/$i/json");
      if (i == 0) {
        _getBanner(httpClient);
      }
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        status = 0;
        var json = await response.transform(UTF8.decoder).join();
        var fromJson = ArticleEntity
            .fromJson(json)
            .data;
        total = fromJson.total;
        articles.addAll(fromJson.datas);
      } else {
        status = -1;
      }
    } catch (exception) {
      print(exception.toString());
      status = -1;
    }
    setState(() {});
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
          itemCount: articles.length + 1,
          physics: new AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: _controller,
          itemBuilder: (context, index) {
            if (index == 0) {
              return new Container(
                height: 210.0,
                child: new SlideView(bannerList),
              );
            }
            index = index - 1;
            return new InkWell(
              onTap: () {
                // 点击跳转到详情
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (ctx) => new NewsDetail(id:articles[index].link )
                ));
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(articles[index].title,
                      style: new TextStyle(fontWeight: FontWeight.bold)),
                  new Text(articles[index].author),
                  new Divider()
                ],
              ),
            );
          }
      ),
      onRefresh: () {
        articles.clear();
        pageIndex = 0;
        setState(() {});
        _getArticle(pageIndex);
      },);
  }

}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

//  在Dart语言中使用下划线前缀标识符，会强制其变成私有的

//_suggestions列表以保存建议的单词对
  final _suggestions = <WordPair>[];

//添加一个biggerFont变量来增大字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

//  这个集合存储用户喜欢（收藏）的单词对。在这里，Set比List更合适，因为Set中不允许重复的值
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该行书湖添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return new Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
        // 如果是建议列表中最后一个单词对
        if (index >= _suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair suggestion) {
    final alreadySaved = _saved.contains(suggestion);
    return new ListTile(
      title: new Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(suggestion);
          } else {
            _saved.add(suggestion);
          }
        });
      },
    );
  }
}