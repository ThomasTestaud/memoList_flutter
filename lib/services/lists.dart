import './api.dart';
import 'dart:convert';
import './matches.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyList {
  int id;
  String name;
  String description;
  List<Match> matches = [];

  MyList({required this.id, required this.name, required this.description, this.matches = const []});

  // Convert a MyList object to a map, including the matches
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      // Convert the list of Match objects to a list of maps
      'matches': matches.map((match) => match.toMap()).toList(),
    };
  }

  // Create a MyList object from a map
  factory MyList.fromMap(Map<String, dynamic> map) {
    var matchesList = map['matches'] as List;
    List<Match> matches = matchesList.map((matchMap) => Match.fromMap(matchMap)).toList();
    
    return MyList(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      matches: matches,
    );
  }
}

class MyListFactory {
  static List<MyList> lists = [];

  static List<MyList> buildListFromApi(response) {
    MyListFactory.lists.clear();

    for (var item in response) {
      List<Match> matches = [];
      if (item['Matches'] != null) {
        for (var matchItem in item['Matches']) {
          Match match = Match(
            id: matchItem['id'],
            textToMatch: matchItem['textToMatch'],
            matchingText: matchItem['matchingText'],
          );
          matches.add(match);
        }
      }

      MyList myList = MyList(
        id: item['id'],
        name: item['name'],
        description: item['description'],
        matches: matches, // Add the parsed matches here
      );
      MyListFactory.lists.add(myList);
    }

    return MyListFactory.lists;
  }
}




class ServiceList {
  static List<MyList> lists = [];
  static bool online = true;

  static Future<List<MyList>> getList() async {
    if(online) {
      var res = await ServiceList.getListFromAPI();
      await ServiceList.saveMyListFromStorage(res);
      
      return res;
    } else {
      var res = await ServiceList.getMyListFromStorage();
      return res;
    }
  }

  static Future<void> postList(MyList data) async {
    var api = Api();
    var response = await api.post('/list', {"name": data.name, "description": data.description });
    print(response);
  }

  static Future<List<MyList>> getListFromAPI() async {
    var api = Api();
    var response = await api.get('/list');
    print(response);
    return MyListFactory.buildListFromApi(response);
  }

  static Future<void> postListFromAPI(MyList data) async {
    var api = Api();
    var response = await api.post('/list', {"name": data.name, "description": data.description });
    print(response);
  }

   static Future<void> saveMyListFromStorage(List<MyList> myList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map> myListMap = myList.map((item) => item.toMap()).toList();
    String jsonString = jsonEncode(myListMap);
    await prefs.setString('myListKey', jsonString);
  }

  static Future<List<MyList>> getMyListFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('myListKey');
    if (jsonString != null) {
      List<dynamic> jsonMap = jsonDecode(jsonString);
      List<MyList> myList = jsonMap.map((item) => MyList.fromMap(item)).toList();
      return myList;
    } else {
      return [];
    }
  }

  static Future<void> postMatch(Match data, int id) async {
    var api = Api();
    var response = await api.post('/match/$id', {"textToMatch": data.textToMatch, "matchingText": data.matchingText });
    ServiceList.getList();
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
