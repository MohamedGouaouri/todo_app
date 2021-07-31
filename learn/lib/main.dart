import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LearnApp(),
    ));

class Task {
  String title;
  bool checked;
  Task({required this.title, required this.checked});
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = "";

  // handle submit
  _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      // insert to the db
      var newTask = Task(title: _title, checked: false);
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              "Add Task",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Form(
              key: _formkey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        validator: (input) =>
                            input!.isEmpty ? "Please enter a title" : null,
                        onSaved: (input) => _title = input!,
                        initialValue: _title,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        //color: Theme.of(context).primaryColor,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextButton(
                          onPressed: _submit,
                          child: Text(
                            "Add",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LearnApp extends StatefulWidget {
  const LearnApp({Key? key}) : super(key: key);

  @override
  _LearnAppState createState() => _LearnAppState();
}

class _LearnAppState extends State<LearnApp> {
  List<Task> _tasks = [Task(title: "Study flutter", checked: false)];

  List<CheckboxListTile> _buildTasksWidgets() {
    List<CheckboxListTile> checkBoxTileList = [];

    for (var i = 0; i < _tasks.length; i++) {
      print(_tasks[i].checked);
      checkBoxTileList.add(
        CheckboxListTile(
          value: _tasks[i].checked,
          onChanged: (bool? input) {
            setState(() {
              _tasks[i].checked = input!;
            });
          },
          title: Text(
            _tasks[i].title,
            style: TextStyle(
                decoration: _tasks[i].checked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ),
      );
    }
    return checkBoxTileList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Learn App",
        ),
        actions: [
          IconButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildTasksWidgets(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTaskScreen()));
          print(task.title);
          setState(() {
            _tasks.add(task);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
