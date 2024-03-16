import 'package:flutter/material.dart';
import '../services/matches.dart';
import '../services/lists.dart';
import './newMatch.dart';
import './trainingSession.dart';

class MatchesPage extends StatefulWidget {
  final MyList list;

  const MatchesPage({Key? key, required this.list}) : super(key: key);

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  bool showAnswer = false;
  bool selection = false;
  List<Match> matches = [];

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  void loadLists() async {
    var loadedLists = widget.list.matches;
    setState(() {
      matches = loadedLists;
    });
  }

  void startTraining(MyList list) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TrainingSessionPage(list: list)),
    );
  }

  void selectMatch(Match match) {
    setState(() {
      if(ServiceMatch.matches.contains(match)) {
        ServiceMatch.matches.remove(match);
      } else {
        ServiceMatch.matches.add(match);
      }
    });
  }

  bool isSelected(Match match) {
    return ServiceMatch.matches.contains(match);
  }

  void activateSelection() {
    setState(() {
      if (selection) {
        ServiceMatch.matches = widget.list.matches;
      } else {
        ServiceMatch.matches = [];
      }
      selection = !selection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 255, 200, 0),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: showAnswer ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      showAnswer = !showAnswer;
                    });
                  },
                ),
                IconButton(icon: Icon(
                  Icons.check_box,
                  color: selection ? Colors.blue : Colors.grey,
                ),
                  onPressed: () {
                    activateSelection();
                  },
                ),
                ServiceList.online ? IconButton(
                  icon: Icon(Icons.add, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewMatchPage(
                              list: widget.list)),
                    );
                  },
                ) : Text('Offiline mode', style: TextStyle(color: Colors.grey)
                ,)
              ],
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
            ),
          ),
          Expanded(
            // This ensures the list takes all available space
            child: matches.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      var match = matches[index];
                      return Card(
                        elevation: 4.0,
                        margin: index == matches.length -1
                            ? EdgeInsets.only(
                                top: 8.0,
                                bottom:
                                    88.0, // Original vertical value (8.0) + your additional bottom margin (80)
                                left: 16.0,
                                right: 16.0,
                              )
                            : EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: 
                          SizedBox(
                                width:
                                    35, // Adjust the width accordingly to fit the IconButton
                                height:
                                    35, // Adjust the height accordingly (optional)
                                child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${match.textToMatch}',
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (showAnswer)
                                Text(
                                  ' = ${match.matchingText}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 182, 142, 0),
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (selection)
                                IconButton(
                                  icon: Icon(
                                    Icons.check_box,
                                    color: isSelected(match)
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    selectMatch(match);
                                  },
                                ),
                            ],
                          ),),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Color.fromARGB(255, 255, 200, 0),
                              width: 2),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            startTraining(widget.list);
          },
          child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Start training', style: TextStyle(fontSize: 20))),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(
                255, 255, 200, 0), // Button color matching MemoList
            onPrimary: Colors.white, // Text color
            minimumSize: Size(double.infinity, 36),
          ),
        ),
      ),
    );
  }
}
