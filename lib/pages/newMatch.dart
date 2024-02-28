import 'package:flutter/material.dart';
import '../services/matches.dart';
import './matches.dart';

class NewMatchPage extends StatefulWidget {
  final int id;
  final String listName;

  const NewMatchPage({Key? key, required this.id, required this.listName}) : super(key: key);

  @override
  _NewMatchPageState createState() => _NewMatchPageState(id, listName);
}

class _NewMatchPageState extends State<NewMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final int id;
  final String listName;
  String _textToMatch = '';
  String _matchingText = '';

  _NewMatchPageState(this.id, this.listName);

  @override
  Widget build(BuildContext context) {
    void create() {
      Match newMatch = Match(textToMatch: _textToMatch, matchingText: _matchingText);

      ServiceMatch.postMatch(newMatch, id);
      
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchesPage(id: id, listName: listName)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('New Match'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Text to Match'),
                maxLines: null, 
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _textToMatch = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Matching text'),
                maxLines: null, 
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    _matchingText = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    create();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
