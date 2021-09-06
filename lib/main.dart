import 'package:flutter/material.dart';
// import 'package:todo_app/appwrite.dart';
import 'package:todo_app/screens/todo_list_screen.dart';

// import 'package:appwrite/appwrite.dart';

void main() async {
  // client = Client();
  // db = Database(client);
  // account = Account(client);
  // client
  //         .setEndpoint('http://worker:8081/v1') // Your API Endpoint
  //         .setProject('61347943e5657') // Your project ID
  //     ;
  // await account.createSession(
  //     email: "mohamedgouari2000@gmail.com", password: "secret");
  runApp(MaterialApp(
    home: TodoListScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
  ));
}
