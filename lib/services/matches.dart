import './api.dart';
import './lists.dart';

class Match {
  int? id;
  String textToMatch;
  String matchingText;

  Match({this.id, required this.textToMatch, required this.matchingText});

  // Convert a Match object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'textToMatch': textToMatch,
      'matchingText': matchingText,
    };
  }

  // Create a Match object from a map
  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      textToMatch: map['textToMatch'],
      matchingText: map['matchingText'],
    );
  }
}

class MatchFactory {
  static MyList currentList = MyList(id: 0, name: '', description: '');
  static List<Match> matches = [];

  static List<Match> buildListFromApi(response) {
    MatchFactory.matches.clear();

    for (var item in response['Matches']) {
      Match match = Match(
        id: item['id'],
        textToMatch: item['textToMatch'],
        matchingText: item['matchingText'],
      );
      MatchFactory.matches.add(match);
    }

    return MatchFactory.matches;
  }
}

class ServiceMatch {
  static List<Match> matches = [];

  static Future<void> postMatch(Match data, int id) async {
    var api = Api();
    await api.post('/match/$id', {"textToMatch": data.textToMatch, "matchingText": data.matchingText });
    //print(response);
    // Push the new match (data) to the list at the correct id
    for (var i = 0; i < MyListFactory.lists.length; i++) {
      if (MyListFactory.lists[i].id == id) {
        MyListFactory.lists[i].matches.add(data);
      }
    }
    await ServiceList.saveMyListFromStorage(MyListFactory.lists);
  }
}
