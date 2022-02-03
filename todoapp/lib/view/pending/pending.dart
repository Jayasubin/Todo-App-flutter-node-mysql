import 'package:flutter/material.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/constants/navigation.dart';
import 'package:todoapp/service/todo_service.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/view/widgets/add_alert.dart';
import 'package:todoapp/view/widgets/custom_list_tile.dart';

class Pending extends StatefulWidget {
  static const pageID = 'active';

  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  List<Widget> pendingWidgets = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    print('Getting data');

    List<Todo> pending = await TodoService().getPending();
    pendingWidgets.clear();

    if (pending.isNotEmpty) {
      for (var todo in pending) {
        pendingWidgets.add(CustomListTile(
          currentTodo: todo,
          getData: getData,
        ));
      }
    } else {
      pendingWidgets.add(
        const Center(
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: kDoneColor,
            size: 130,
          ),
        ),
      );
    }

    setState(() {});
    TodoService().showCustomSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending ToDos'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: pendingWidgets,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              child: const Text('Completed Todos'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0)),
              ),
              onPressed: () async {
                bool reload =
                    await Navigator.pushNamed(context, completedPageID) as bool;
                reload ? getData() : {};
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
            builder: (context) => AddAlert(refresh: getData),
          );
        },
      ),
    );
  }
}
