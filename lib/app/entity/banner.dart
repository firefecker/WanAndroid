import 'dart:convert';

import 'package:flutter_app/app/entity/base_entity.dart';

class BannerEntity extends BaseEntity {
  List<BannerData> data;

  @override
  String toString() {
    return 'BannerEntity{data: $data}';
  }

  static BannerEntity fromJson(String json) {
    Map jsonObj = JSON.decode(json);
    BannerEntity entity = new BannerEntity();
    BannerData data = null;
    List<BannerData> result = new List();
    entity.errorCode = jsonObj["errorCode"];
    entity.errorMsg = jsonObj["errorMsg"];
    if (entity.errorCode != 0) {
      entity.data = result;
      return entity;
    }
    List jsonObj2 = jsonObj["data"];
    for (var i = 0; i < jsonObj2.length; i ++) {
      data = new BannerData(jsonObj2[i]["desc"],jsonObj2[i]["id"],jsonObj2[i]["imagePath"],jsonObj2[i]["isVisible"],
          jsonObj2[i]["order"],jsonObj2[i]["title"],jsonObj2[i]["type"],jsonObj2[i]["url"]);
          result.add(data);
    }
    entity.data = result;
    return entity;
  }

}

class BannerData {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;


  BannerData(this.desc, this.id, this.imagePath, this.isVisible, this.order,
      this.title, this.type, this.url);

  @override
  String toString() {
    return 'Data{desc: $desc, id: $id, imagePath: $imagePath, isVisible: $isVisible, order: $order, title: $title, type: $type, url: $url}';
  }


}