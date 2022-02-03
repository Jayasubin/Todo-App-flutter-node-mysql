import 'package:flutter/material.dart';

import '../../service/todo_service.dart';

class AddAlert extends StatelessWidget {
  const AddAlert({Key? key, required this.refresh}) : super(key: key);

  final Function refresh;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    late String title;
    late String description;

    return AlertDialog(
      title: const Text('Add ToDo'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(label: Text('Title')),
              maxLength: 30,
              onSaved: (input) {
                title = input!;
              },
              validator: (input) {
                if (input != null && input.isNotEmpty) {
                  return null;
                }
                return '! Required';
              },
            ),
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(label: Text('Description')),
              maxLines: 2,
              onSaved: (input) {
                description = input!;
              },
              validator: (input) {
                if (input != null && input.isNotEmpty) {
                  return null;
                }
                return '! Required';
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  formKey.currentState!.reset();

                  bool added = await TodoService()
                      .add(title: title, description: description);

                  TodoService().showCustomSnackBar(context);

                  if (added) {
                    refresh();
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check Form'),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
