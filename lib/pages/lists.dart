import 'package:flutter/material.dart';
import '../services/lists.dart';
import './newList.dart';
import './matches.dart'; // Import the Matches page

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<MyList> lists = [];

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  void loadLists() async {
    var loadedLists = await ServiceList.getList();
    setState(() {
      lists = loadedLists;
    });
    print(lists);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: Column(
        children: [
          lists.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      var list = lists[index];
                      return Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          child: Column(
                            children: [
                              Text(list.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(list.description),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchesPage(id: list.id, listName: list.name), // Pass the list id to the Matches page
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: Icon(Icons.add), // Changed to use an Icon for better UX
        backgroundColor: Color(0xFFE57373),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewListPage()),
          );
        },
      ),
    );
  }
}
