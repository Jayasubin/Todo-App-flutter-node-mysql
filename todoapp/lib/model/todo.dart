class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.time,
  });

  int id;
  String title;
  String description;
  DateTime? time;
}
