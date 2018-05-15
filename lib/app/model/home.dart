import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/newsdetail.dart';
import 'package:flutter_app/app/component/slideview.dart';
import 'package:flutter_app/app/entity/article.dart';
import 'package:flutter_app/app/entity/banner.dart';
import 'package:flutter_app/home.dart';

List<Datas> articles = new List();
int status = 0;
List<BannerData> bannerList = new List();
int pageIndex = 0;
int total = 0;

class Home extends StatelessWidget {
  Widget widget;

  Home() {
    widget = new HomeStateless();
  }

  @override
  Widget build(BuildContext context) {
    return widget;
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

  ScrollController _controller = new ScrollController();
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
    if (articles.length == 0) {
      pageIndex = 0;
      _getArticle(pageIndex);
    }
    return _buildHome();
  }


  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        length: bannerList == null ? 0 : bannerList.length, vsync: this);
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
                          Icons.select_all, articles[index].chapterName, 10.0),
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
        setState(() {});
        _getArticle(pageIndex);
      },);
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
}
