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
        title: const Text('Your lists',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor:
            Color.fromARGB(255, 255, 200, 0), // Match MemoList's app bar color
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
                        margin:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(list.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(list.description),
                              ],
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .white, // Match button color with MemoList
                            onPrimary:
                                Colors.black, // Text color for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 255, 200, 0),
                                  width: 2), // Add border to the button
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchesPage(
                                    list: list), // Pass the list id to the Matches page
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
       floatingActionButton: ServiceList.online ? FloatingActionButton(
        elevation: 0.0,
        child: Icon(Icons.add,
            color: Colors.white), // Match Icon color with MemoList
        backgroundColor:
            Color.fromARGB(255, 255, 200, 0), // Match FAB color with MemoList
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewListPage()),
          );
        },
      ) : Container(),
    );
  }
}
