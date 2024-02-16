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
        title: Text('New List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
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
