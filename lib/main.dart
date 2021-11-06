import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red[800],
      ),
      home: MyHomePage(title: '  ToDo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> quotes = [];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getTodo();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red[800],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 14),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 13.0, bottom: 8, left: 8, right: 8),
              child: Text(
                "Done",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (quotes.length != 0)
                  ? quotes.map((e) {
                      return ListTile(
                        title: Text(e),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              quotes.remove(e);
                              saveTodo();
                            });
                          },
                        ),
                      );
                    }).toList()
                  : [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Nothing yet"),
                      )
                    ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.red[800],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Todo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter the text"),
                ),
                Divider(
                  thickness: 0,
                  height: 20,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (!(_textController.text == "")) {
                  setState(() {
                    quotes.add(_textController.text);
                    saveTodo();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  saveTodo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setStringList('todo', quotes);
  }

  getTodo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String>? todo = sp.getStringList('todo');
    if (todo != null) {
      setState(() {
        quotes = todo;
      });
    } else {
      setState(() {
        quotes = [];
      });
    }
  }
}
