class Task {
  int? id;
  String title;
  DateTime date;
  int status;

  Task({required this.title, required this.date, required this.status});
  Task.withId(
      {required this.id,
      required this.title,
      required this.date,
      required this.status});

  // to_map function used for datebase operations
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this.id;
    map["title"] = this.title;
    map["date"] = this.date.toIso8601String();
    map["status"] = this.status;
    return map;
  }

  // convert map back to Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map["id"],
        title: map["title"],
        date: DateTime.parse(map["date"]),
        status: map["status"]);
  }
}
