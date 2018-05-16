import 'dart:convert';

import 'package:flutter_app/app/entity/base_data.dart';
import 'package:flutter_app/app/entity/base_entity.dart';


class Collect extends BaseEntity {
  Data data;

  @override
  String toString() {
    return 'Data{datas: $data}';
  }

  static Collect fromJson(String json) {
    Map jsonObj = JSON.decode(json);
    Collect entity = new Collect();
    Data data = new Data();
    List<Datas> result = [];
    entity.errorCode = jsonObj["errorCode"];
    entity.errorMsg = jsonObj["errorMsg"];
    if (entity.errorCode != 0) {
      data.datas = result;
      entity.data = data;
      return entity;
    }
    Map jsonObj2 = jsonObj["data"];
    data.currentPage = jsonObj2["curPage"];
    data.offset = jsonObj2["offset"];
    data.over = jsonObj2["over"];
    data.pageCount = jsonObj2["pageCount"];
    data.size = jsonObj2["size"];
    data.total = jsonObj2["total"];
    List jsonObj3 = jsonObj2["datas"];
    Datas datas = null;
    for (var i = 0; i < jsonObj3.length; i ++) {
      datas = new Datas(jsonObj3[i]["author"], jsonObj3[i]["chapterId"], jsonObj3[i]["chapterName"],
          jsonObj3[i]["courseId"], jsonObj3[i]["desc"], jsonObj3[i]["envelopePic"],
          jsonObj3[i]["id"], jsonObj3[i]["link"], jsonObj3[i]["niceDate"],
          jsonObj3[i]["origin"], jsonObj3[i]["originId"], jsonObj3[i]["publishTime"],
          jsonObj3[i]["title"], jsonObj3[i]["userId"], jsonObj3[i]["visible"], jsonObj3[i]["zan"]);
      result.add(datas);
    }
    data.datas = result;
    entity.data = data;
    return entity;
  }

}

class Data extends BaseData {

  List<Datas> datas;

  @override
  String toString() {
    return 'Data{datas: $datas}';
  }


}

class Datas {
  String author;
  int chapterId;
  String chapterName;
  int courseId;
  String desc;
  String envelopePic;
  int id;
  String link;
  String niceDate;
  String origin;
  int originId;
  int publishTime;
  String title;
  int userId;
  int visible;
  int zan;

  Datas(this.author, this.chapterId, this.chapterName, this.courseId, this.desc,
      this.envelopePic, this.id, this.link, this.niceDate, this.origin,
      this.originId, this.publishTime, this.title, this.userId, this.visible,
      this.zan);

  @override
  String toString() {
    return 'Datas{author: $author, chapterId: $chapterId, chapterName: $chapterName, courseId: $courseId, desc: $desc, envelopePic: $envelopePic, id: $id, link: $link, niceDate: $niceDate, origin: $origin, originId: $originId, publishTime: $publishTime, title: $title, userId: $userId, visible: $visible, zan: $zan}';
  }


}
