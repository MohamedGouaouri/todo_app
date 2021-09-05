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

  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = [
        Task(title: "Learn flutter", date: DateTime.now(), status: 0)
      ];
    });
  }

  fetchTasks() async {
    var response = await db.listDocuments(collectionId: "61349088f0737");
    return response;
  }

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
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              formatter.format(task.date),
              style: TextStyle(
                  fontSize: 15.0,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              value: false,
              onChanged: (value) {
                task.status = value! ? 1 : 0;
              },
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)));
            },
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        actions: [
          // exit button
          IconButton(
              onPressed: () => {}, icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: FutureBuilder(
        future: fetchTasks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: snapshot.data['sum'] + 1,
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
                          "count",
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

                return _buildTask(Task.fromMap({
                  "id": snapshot.data['documents'][index]['id'],
                  'title': snapshot.data['documents'][index]['title'],
                  'date': snapshot.data['documents'][index]['date'],
                  'status': snapshot.data['documents'][index]['status']
                }));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        // navigate to add task screen
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddTaskScreen())),
        tooltip: 'Add todo',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
