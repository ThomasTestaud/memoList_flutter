import 'package:flutter/material.dart';
import '../services/matches.dart';
import './newMatch.dart';
import './trainingSession.dart';

class MatchesPage extends StatefulWidget {
  final int id;
  final String listName;

  const MatchesPage({Key? key, required this.id, required this.listName}) : super(key: key);

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  List<Match> matches = [];

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  void loadLists() async {
    var loadedLists = await ServiceMatch.getMatch(widget.id); // Use widget.id here
    setState(() {
      matches = loadedLists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName), // Use widget.listName here
      ),
      body: Column(
        children: [
          matches.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      var match = matches[index];
                      return Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text('${match.textToMatch} = ', overflow: TextOverflow.clip),
                            ),
                            Flexible(
                              child: Text(match.matchingText, style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.clip),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainingSessionPage(id: widget.id, listName: widget.listName)), // Use widget.id and widget.listName here
                  )
                }, child: const Text('Start training')),
                SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFE57373),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMatchPage(id: widget.id, listName: widget.listName)), // Use widget.id and widget.listName here
          );
        },
      ),
    );
  }
}
