import 'package:flutter/material.dart';

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
  List<ToDo> quotes = [];

  final _textController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                "Pending",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (quotes.length != 0)
                  ? quotes.map((e) {
                      if (!e.done) {
                        return ListTile(
                          title: Text(e.text),
                          subtitle: Text(e.author),
                          trailing: IconButton(
                            icon: Icon(Icons.done),
                            onPressed: () {
                              setState(() {
                                e.setasDone();
                              });
                            },
                          ),
                        );
                      } else {
                        return SizedBox(
                          width: 0,
                        );
                      }
                    }).toList()
                  : [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Nothing yet"),
                      )
                    ],
            ),
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
                      if (e.done) {
                        return ListTile(
                          title: Text(e.text),
                          subtitle: Text(e.author),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                quotes.remove(e);
                              });
                            },
                          ),
                        );
                      } else {
                        return SizedBox(
                          width: 0,
                        );
                      }
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
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Author name"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (!(_textController.text == "" &&
                    _authorController.text == "")) {
                  setState(() {
                    quotes.add(
                        ToDo(_textController.text, _authorController.text));
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
}

class ToDo {
  late String text;
  late String author;
  bool done = false;

  ToDo(String text, String author) {
    this.text = text;
    this.author = author;
  }

  void setasDone() {
    this.done = true;
  }

  void setasUnDone() {
    this.done = false;
  }
}
