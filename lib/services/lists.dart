import './api.dart';
import 'dart:convert';

class MyList {
  int? id;
  String name;
  String description;

  MyList({this.id, required this.name, required this.description});
}

class MyListFactory {
  static List<MyList> lists = [];

  static List<MyList> buildListFromApi(response) {
    ServiceList.lists.clear();

    for (var item in response) {
      MyList myList = MyList(
        id: item['id'],
        name: item['name'],
        description: item['description'],
      );
      ServiceList.lists.add(myList);
    }

    return ServiceList.lists;
  }
}

class ServiceList {
  static List<MyList> lists = [];

  static Future<List<MyList>> getList() async {
    var api = Api();
    var response = await api.get('/list');

    return MyListFactory.buildListFromApi(response);
  }

  static Future<void> postList(MyList data) async {
    var api = Api();
    var response = await api.post('/list', {"name": data.name, "description": data.description });
    print(response);
  }
}

class MyListBuilder {
  int? id;
  String? name;
  String? description;

  MyListBuilder setId(int id) {
    this.id = id;
    return this;
  }

  MyListBuilder setName(String name) {
    this.name = name;
    return this;
  }

  MyListBuilder setDescription(String description) {
    this.description = description;
    return this;
  }

  MyList build() {
    return MyList(
      id: id ?? 0,
      name: name ?? '',
      description: description ?? '',
    );
  }
}
