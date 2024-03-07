import 'package:flutter/material.dart';
import '../services/lists.dart';
import './lists.dart';

class NewListPage extends StatefulWidget {
  @override
  _NewListPageState createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  MyListBuilder builder = MyListBuilder();

  @override
  Widget build(BuildContext context) {
  void create() {
    MyList newList = builder.setName(_name).setDescription(_description).build();

    ServiceList.postList(newList);
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListsPage()),
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: Text('New list', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: Color.fromARGB(255, 255, 200, 0), // Match MemoList's app bar color
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Color.fromARGB(255, 157, 123, 0)), // Custom label color matching MemoList
                prefixIcon: Icon(Icons.text_fields, color: Colors.black), // Add an icon with a custom color
                border: OutlineInputBorder(), // Adds border to the TextFormField
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Color.fromARGB(255, 157, 123, 0)), // Custom label color matching MemoList
                prefixIcon: Icon(Icons.description, color: Colors.black), // Add an icon with a custom color
                border: OutlineInputBorder(), // Adds border to the TextFormField
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
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
                primary: Color.fromARGB(255, 255, 200, 0), // Button color matching MemoList
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
