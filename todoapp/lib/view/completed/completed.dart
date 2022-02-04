import 'package:flutter/material.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/service/todo_service.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/view/widgets/add_alert.dart';
import 'package:todoapp/view/widgets/custom_list_tile.dart';

class Completed extends StatefulWidget {
  static const String pageID = 'completed';

  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  List<Widget> completedWidgets = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    List<Todo> completed = await TodoService().getCompleted();
    completedWidgets.clear();

    if (completed.isNotEmpty) {
      for (var todo in completed) {
        completedWidgets
            .add(CustomListTile(currentTodo: todo, getData: getData));
      }
    } else {
      completedWidgets.add(
        const Center(
          child: Icon(
            Icons.hourglass_empty_rounded,
            color: kDoneColor,
            size: 100,
          ),
        ),
      );
    }

    setState(() {});
    TodoService().showCustomSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Completed ToDos'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: completedWidgets,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                child: const Text('Pending Todos'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddAlert(refresh: () {}),
            );
          },
        ),
      ),
    );
  }
}
