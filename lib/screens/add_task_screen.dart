import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:todo_app/appwrite.dart';
import 'package:todo_app/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key? key, Task? task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = "";
  DateTime _date = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _dateController.text = formatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = formatter.format(_date);
    }
  }

  // handle onPressed Add task
  _submit() {
    // check if everything is valid
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      // insert to the db
      var newTask = Task(title: _title, date: _date, status: false);
      // Future result = db.createDocument(
      //     collectionId: "61349088f0737", data: newTask.toMap());
      // result.then((value) => print(value)).catchError((error) => print(error));
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
                            input!.isEmpty ? "Please enter a task title" : null,
                        onSaved: (input) => _title = input!,
                        initialValue: _title,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        onTap: _handleDatePicker,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                            labelText: "Date",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
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
