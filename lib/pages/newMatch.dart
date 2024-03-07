import 'package:flutter/material.dart';
import '../services/matches.dart';
import '../services/lists.dart';
import './matches.dart';

class NewMatchPage extends StatefulWidget {
  final MyList list;

  const NewMatchPage({Key? key, required this.list})
      : super(key: key);

  @override
  _NewMatchPageState createState() => _NewMatchPageState(list);
}

class _NewMatchPageState extends State<NewMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final MyList list;
  String _textToMatch = '';
  String _matchingText = '';

  _NewMatchPageState(this.list);

  @override
  Widget build(BuildContext context) {

    void create() async {
      Match newMatch =
          Match(textToMatch: _textToMatch, matchingText: _matchingText);

      await ServiceMatch.postMatch(newMatch, list.id);

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MatchesPage(list: list)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('New Match',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor:
            Color.fromARGB(255, 255, 200, 0), // Match the vibrant yellow theme
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Text to Match',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(
                          255, 157, 123, 0)), // Custom label color
                  border: OutlineInputBorder(), // Adds border
                  prefixIcon: Icon(Icons.text_fields,
                      color: Color.fromARGB(255, 157, 123, 0)), // Add an icon
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter text to match';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _textToMatch = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Matching text',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(
                          255, 157, 123, 0)), // Custom label color
                  border: OutlineInputBorder(), // Adds border
                  prefixIcon: Icon(Icons.question_answer,
                      color: Color.fromARGB(255, 157, 123, 0)), // Add an icon
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    _matchingText = value;
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    create();
                  }
                },
                child: Text('Submit', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(
                      255, 255, 200, 0), // Button color matching MemoList
                  onPrimary: Colors.white, // Text color
                  minimumSize: Size(double.infinity, 50), // Button size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
