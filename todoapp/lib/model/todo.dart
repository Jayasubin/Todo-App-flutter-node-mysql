class Todo {
  Todo({
    required this.id,
    required this.title,
    this.description,
    this.attachment,
    this.time,
  });

  int id;
  String title;
  String? description;
  String? attachment;
  DateTime? time;
}
