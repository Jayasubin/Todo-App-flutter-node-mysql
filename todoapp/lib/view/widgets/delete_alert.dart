import 'package:flutter/material.dart';
import 'package:todoapp/service/todo_service.dart';

class DeleteAlert extends StatelessWidget {
  const DeleteAlert({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this Todo?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.redAccent),
          ),
          onPressed: () async {
            bool deleted = await TodoService().delete(id: id);
            TodoService().showCustomSnackBar(context);
            Navigator.pop(context, deleted);
          },
        ),
      ],
    );
  }
}
