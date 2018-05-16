import 'dart:convert';

import 'package:flutter_app/app/entity/base_entity.dart';


class UserEntity extends BaseEntity {
  Data data;
  @override
  String toString() {
    return 'UserEntity{data: $data}';
  }

  static UserEntity fromJson(String json) {
    Map jsonObj = JSON.decode(json);
    UserEntity userEntity = new UserEntity();
    userEntity.errorCode = jsonObj["errorCode"];
    userEntity.errorMsg = jsonObj["errorMsg"];
    if (userEntity.errorCode != 0) {
      return userEntity;
    }
    Map jsonObj1 = jsonObj["data"];
    List jsonObj2 = jsonObj1["collectIds"];
    List<int> results = [];
    for (var i = 0; i < jsonObj2.length; i ++) {
      results.add(jsonObj2[i]);
    }
    Data data = new Data(results, jsonObj1["email"], jsonObj1["icon"], jsonObj1["id"], jsonObj1["password"], jsonObj1["type"], jsonObj1["username"]);
    userEntity.data = data;
    return userEntity;
  }
}

class Data {
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String password;
  int type;
  String username;
  Data(this.collectIds, this.email, this.icon, this.id, this.password,
      this.type, this.username);
  @override
  String toString() {
    return 'Data{collectIds: $collectIds, email: $email, icon: $icon, id: $id, password: $password, type: $type, username: $username}';
  }
}