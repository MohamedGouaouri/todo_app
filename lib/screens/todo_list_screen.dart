import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/appwrite.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  late List<Task> _taskList;
  int completedTasks = 0;

  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _taskList = [];
  }

  // fetchTasks() async {
  //   var response = await db.listDocuments(collectionId: "61349088f0737");
  //   return response;
  // }

  // Build task Widget
  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  fontSize: 18.0,
                  decoration: task.status == false
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              formatter.format(task.date),
              style: TextStyle(
                  fontSize: 15.0,
                  decoration: task.status == false
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              value: task.status,
              onChanged: (value) {
                setState(() {
                  task.status = value! ? true : false;
                  if (task.status) {
                    completedTasks++;
                  } else {
                    completedTasks--;
                  }
                });
              },
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  showAddTaskScreen() async {
    var newTask = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddTaskScreen()));
    setState(() {
      _taskList.add(newTask);
    });
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("Task added"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _taskList.removeLast();
              });
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo App"),
        actions: [
          // exit button
          IconButton(
              onPressed: () => {}, icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _taskList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Taks",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$completedTasks / ${_taskList.length}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            // build a new task to the screen

            return _buildTask(_taskList[index - 1]);
          }),
      floatingActionButton: FloatingActionButton(
        // navigate to add task screen

        onPressed: () {
          showAddTaskScreen();
        },
        tooltip: 'Add todo',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
