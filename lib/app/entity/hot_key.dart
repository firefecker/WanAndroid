import 'dart:convert';

import 'package:flutter_app/app/entity/base_entity.dart';


class HotEntity extends BaseEntity {

  List<Data> data;

  static List<Data> fromJson(String json) {
    Map jsonObj = JSON.decode(json);
    int errorCode = jsonObj["errorCode"];
    List<Data> datas = [];
    if (errorCode != 0) {
      return datas;
    }
    List jsonObj2 = jsonObj["data"];
    Data data = null;
    for (var i = 0; i < jsonObj2.length; i ++) {
      data = new Data(
          jsonObj2[i]["id"], jsonObj2[i]["link"], jsonObj2[i]["name"],
          jsonObj2[i]["order"], jsonObj2[i]["visible"]);
      datas.add(data);
    }
    return datas;
  }


  HotEntity(this.data);

  @override
  String toString() {
    return 'HotEntity{data: $data}';
  }


}

class Data {
  int id;
  String link;
  String name;
  int order;
  int visible;

  Data(this.id, this.link, this.name, this.order, this.visible);

  @override
  String toString() {
    return 'Data{id: $id, link: $link, name: $name, order: $order, visible: $visible}';
  }


}