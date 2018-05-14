import 'dart:convert';

import 'package:flutter_app/app/entity/base_data.dart';
import 'package:flutter_app/app/entity/base_entity.dart';


class ArticleEntity extends BaseEntity {

  Data data;

  static ArticleEntity fromJson(String json) {
    Map jsonObj = JSON.decode(json);
    ArticleEntity entity = new ArticleEntity();
    Data data = new Data();
    entity.errorCode = jsonObj["errorCode"];
    entity.errorMsg = jsonObj["errorMsg"];
    Map jsonObj2 = jsonObj["data"];
    data.currentPage = jsonObj2["curPage"];
    data.offset = jsonObj2["offset"];
    data.over = jsonObj2["over"];
    data.pageCount = jsonObj2["pageCount"];
    data.size = jsonObj2["size"];
    data.total = jsonObj2["total"];
    List jsonObj3 = jsonObj2["datas"];

    List<Datas> result = [];
    Datas datas = null;
    for (var i = 0; i < jsonObj3.length; i ++) {
      datas = new  Datas(jsonObj3[i]["apkLink"], jsonObj3[i]["author"], jsonObj3[i]["chapterId"],
          jsonObj3[i]["chapterName"], jsonObj3[i]["collect"], jsonObj3[i]["courseId"],
          jsonObj3[i]["desc"], jsonObj3[i]["envelopePic"], jsonObj3[i]["fresh"],
          jsonObj3[i]["id"], jsonObj3[i]["link"], jsonObj3[i]["niceDate"],
          jsonObj3[i]["origin"], jsonObj3[i]["projectLink"], jsonObj3[i]["publishTime"],
          jsonObj3[i]["superChapterId"], jsonObj3[i]["superChapterName"], jsonObj3[i]["title"], jsonObj3[i]["type"],
          jsonObj3[i]["userId"], jsonObj3[i]["visible"], jsonObj3[i]["zan"]);
      result.add(datas);
    }
    data.datas = result;
    entity.data = data;
    return entity;
  }

  @override
  String toString() {
    return 'ArticleEntity{data: $data}';
  }


}

class Data extends BaseData{

  List<Datas> datas;

  @override
  String toString() {
    return 'Data{datas: $datas}';
  }


}

class Datas {
  String apkLink;
  String author;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String origin;
  String projectLink;
  int publishTime;
  int superChapterId;
  String superChapterName;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  Datas(this.apkLink, this.author, this.chapterId, this.chapterName,
      this.collect, this.courseId, this.desc, this.envelopePic, this.fresh,
      this.id, this.link, this.niceDate, this.origin, this.projectLink,
      this.publishTime, this.superChapterId, this.superChapterName,
      this.title, this.type, this.userId, this.visible, this.zan);

  @override
  String toString() {
    return 'Datas{apkLink: $apkLink, author: $author, chapterId: $chapterId, chapterName: $chapterName, collect: $collect, courseId: $courseId, desc: $desc, envelopePic: $envelopePic, fresh: $fresh, id: $id, link: $link, niceDate: $niceDate, origin: $origin, projectLink: $projectLink, publishTime: $publishTime, superChapterId: $superChapterId, superChapterName: $superChapterName, title: $title, type: $type, userId: $userId, visible: $visible, zan: $zan}';
  }


}