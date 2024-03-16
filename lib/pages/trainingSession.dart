import 'package:flutter/material.dart';
import '../services/matches.dart';
import '../services/lists.dart';
import 'dart:math';

class TrainingSessionPage extends StatefulWidget {
  final MyList list;

  const TrainingSessionPage(
      {Key? key, required this.list})
      : super(key: key);

  @override
  _TrainingSessionPageState createState() => _TrainingSessionPageState();
}

class _TrainingSessionPageState extends State<TrainingSessionPage> {
  List<Match> matches = ServiceMatch.matches;
  int index = 0;
  String input = '';
  String mode = 'normal';
  bool showAnswer = false;

  TextEditingController inputController = TextEditingController();

  void verifyAnswer() {
    if (matches[index].matchingText.toLowerCase() == input.toLowerCase()) {
      // Clear the input and move to the next match
      input = '';
      inputController.clear();
      nextMatch();

      // Show a SnackBar for a correct answer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correct! Good job.'),
          backgroundColor:
              Colors.green, // Optional: Set color to green for correct answers
          duration:
              Duration(seconds: 2), // Optional: Adjust the duration as needed
        ),
      );
    } else {
      // Show a SnackBar for an incorrect answer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect. Try again!'),
          backgroundColor:
              Colors.red, // Optional: Set color to red for incorrect answers
          duration:
              Duration(seconds: 2), // Optional: Adjust the duration as needed
        ),
      );
    }
  }

  void nextMatch() {
    if (mode == 'shuffle') {
      setState(() {
        var random = Random();
        index = random.nextInt(matches.length);
      });
    } else if (mode == 'normal') {
      if (index < matches.length - 1) {
        setState(() {
          index++;
        });
      } else {
        setState(() {
          index = 0;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadLists();
  }
  
  void loadLists() async {
    var loadedLists = ServiceMatch.matches;
        //await ServiceMatch.getMatch(widget.id); // Use widget.id here
    setState(() {
      matches = loadedLists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor:
            Color.fromARGB(255, 255, 200, 0), // Match the vibrant yellow theme
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.shuffle,
                    color: mode == 'shuffle' ? Colors.blue : Colors.grey),
                onPressed: () {
                  setState(() {
                    mode = 'shuffle';
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.keyboard_double_arrow_right,
                    color: mode == 'normal' ? Colors.blue : Colors.grey),
                onPressed: () {
                  setState(() {
                    mode = 'normal';
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_red_eye,
                    color: showAnswer ? Colors.blue : Colors.grey),
                onPressed: () {
                  setState(() {
                    showAnswer = !showAnswer;
                  });
                },
              )
            ],
          ),
          matches.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        matches[index].textToMatch,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      showAnswer
                          ? Text(matches[index].matchingText,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 255, 200, 0)))
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: inputController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // Adds border
                            labelText: 'Your Answer',
                            labelStyle: TextStyle(
                                color: Color.fromARGB(
                                    255, 157, 123, 0)), // Custom label color
                            prefixIcon: Icon(Icons.question_answer,
                                color: Color.fromARGB(
                                    255, 157, 123, 0)), // Add an icon
                          ),
                          onChanged: (value) {
                            input = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child:ElevatedButton(
                        onPressed: () {
                          verifyAnswer();
                        },
                        child: Text('Validate', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 200,
                              0), // Button color matching MemoList
                          onPrimary: Colors.white, // Text color
                          minimumSize: Size(double.infinity, 50), // Button size
                        ),
                      ),),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
