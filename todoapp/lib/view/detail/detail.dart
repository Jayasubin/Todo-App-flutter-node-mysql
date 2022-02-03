import 'package:flutter/material.dart';
import 'package:todoapp/view/widgets/delete_alert.dart';
import 'package:todoapp/view/widgets/divider.dart';
import 'package:todoapp/view/widgets/edit_alert.dart';

import 'package:todoapp/model/todo.dart';

class Detail extends StatelessWidget {
  static const String pageID = 'detail';
  const Detail({Key? key, required this.thisTodo}) : super(key: key);

  final Todo thisTodo;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(thisTodo.title),
              const CustomDivider(),
              Text(thisTodo.description),
              const CustomDivider(),
              Text(thisTodo.time != null
                  ? thisTodo.time!.toLocal().toString()
                  : 'N/A'),
              const CustomDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      child: const Text('Delete'),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 40.0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      onPressed: () async {
                        bool deleted = await showDialog(
                            context: context,
                            builder: (context) => DeleteAlert(id: thisTodo.id));

                        if (deleted) {
                          Navigator.pop(context, true);
                        }
                      }),
                  ElevatedButton(
                    child: const Text('Edit'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40.0)),
                    ),
                    onPressed: () async {
                      bool edited = await showDialog(
                        context: context,
                        builder: (context) => EditAlert(toEdit: thisTodo),
                      );
                      edited ? Navigator.pop(context, true) : {};
                    },
                  ),
                ],
              ),
              const CustomDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
