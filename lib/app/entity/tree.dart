import 'dart:convert';

import 'package:flutter_app/app/entity/base_entity.dart';


class DashEntity extends BaseEntity {
  List<Data> data;

  static List<Data> fromJson(String json) {
    Map jsonObj = JSON.decode(json);
    List jsonObj2 = jsonObj["data"];
    List<Data> datas = [];
    Data data = null;
    for (var i = 0; i < jsonObj2.length; i ++) {
      List jsonObj3 = jsonObj2[i]["children"];
      List<Children> childrens = [];
      Children children = null;
      for (var i = 0; i < jsonObj3.length; i ++) {
        children = new Children(
            jsonObj3[i]["courseId"], jsonObj3[i]["id"], jsonObj3[i]["name"],
            jsonObj3[i]["order"], jsonObj3[i]["parentChapterId"],
            jsonObj3[i]["visible"]);
        childrens.add(children);
      }
      data = new Data(
          childrens,
          jsonObj2[i]["courseId"],
          jsonObj2[i]["id"],
          jsonObj2[i]["name"],
          jsonObj2[i]["order"],
          jsonObj2[i]["parentChapterId"],
          jsonObj2[i]["visible"]);
      datas.add(data);
    }
    return datas;
  }
}

class Data {
  List<Children> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  int visible;

  Data(this.children, this.courseId, this.id, this.name, this.order,
      this.parentChapterId, this.visible);

  @override
  String toString() {
    return 'Data{children: $children, courseId: $courseId, id: $id, name: $name, order: $order, parentChapterId: $parentChapterId, visible: $visible}';
  }

}

class Children {
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  int visible;

  Children(this.courseId, this.id, this.name, this.order, this.parentChapterId,
      this.visible);

  @override
  String toString() {
    return 'Children{courseId: $courseId, id: $id, name: $name, order: $order, parentChapterId: $parentChapterId, visible: $visible}';
  }
}