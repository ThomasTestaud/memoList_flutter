import './api.dart';
import './lists.dart';

class Match {
  int? id;
  String textToMatch;
  String matchingText;

  Match({this.id, required this.textToMatch, required this.matchingText});
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

  static Future<List<Match>> getMatch(int id) async {
    var api = Api();
    var response = await api.get('/list/' + id.toString());

    return MatchFactory.buildListFromApi(response);
  }

  static Future<void> postMatch(Match data, int id) async {
    var api = Api();
    var response = await api.post('/match/$id', {"textToMatch": data.textToMatch, "matchingText": data.matchingText });
    print(response);
  }
}
