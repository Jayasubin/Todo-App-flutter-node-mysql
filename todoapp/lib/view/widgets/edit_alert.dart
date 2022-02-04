import 'package:flutter/material.dart';
import 'package:todoapp/service/todo_service.dart';
import 'package:todoapp/model/todo.dart';

class EditAlert extends StatelessWidget {
  const EditAlert({Key? key, /*required this.refresh,*/ required this.toEdit})
      : super(key: key);

  //final Function refresh;
  final Todo toEdit;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    late String title;
    late String? description;

    return AlertDialog(
      title: const Text('Edit ToDo'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              initialValue: toEdit.title,
              maxLength: 30,
              onSaved: (input) {
                if (input != null && input != toEdit.title) {
                  title = input;
                } else {
                  title = toEdit.title;
                }
              },
            ),
            TextFormField(
              autofocus: true,
              initialValue: toEdit.description,
              maxLines: 2,
              onSaved: (input) {
                if (input != null && input != toEdit.description) {
                  description = input;
                } else {
                  description = toEdit.description;
                }
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                formKey.currentState!.save();
                formKey.currentState!.reset();

                bool edited = await TodoService().edit(
                    id: toEdit.id, newTitle: title, newDesc: description ?? '');
                TodoService().showCustomSnackBar(context);
                if (edited) {
                  //refresh();
                  Navigator.pop(context, true);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
