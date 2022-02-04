import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:todoapp/service/todo_service.dart';
import 'package:todoapp/view/widgets/delete_alert.dart';
import 'package:todoapp/view/widgets/divider.dart';
import 'package:todoapp/view/widgets/edit_alert.dart';

import 'package:todoapp/model/todo.dart';

class Detail extends StatefulWidget {
  static const String pageID = 'detail';
  const Detail({Key? key, required this.thisTodoID}) : super(key: key);

  final int thisTodoID;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Todo thisTodo;
  bool isLoading = true;
  @override
  void initState() {
    getDetail();
    super.initState();
  }

  void getDetail() async {
    setState(() {
      isLoading = true;
    });

    thisTodo = await TodoService().getDetail(id: widget.thisTodoID);
    setState(() {
      isLoading = false;
    });
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
          title: const Text('Todo details'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(thisTodo.title),
                    const CustomDivider(),
                    Text(thisTodo.description ?? 'N/A'),
                    const CustomDivider(),
                    Text(thisTodo.time != null
                        ? thisTodo.time!.toLocal().toString()
                        : 'N/A'),
                    const CustomDivider(),
                    const Text('Attachments'),
                    thisTodo.attachment == null
                        ? const Text('N/A')
                        : SizedBox(
                            height: 300,
                            width: 300,
                            child: Image.network(
                                '${TodoService().baseUrl}/image/${widget.thisTodoID}'),
                          ),
                    const CustomDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: const Text('Add Attachment'),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 40.0)),
                          ),
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? pickedImage = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 40);

                            //File attachment = File(pickedImage!.path);

                            bool attached = await TodoService().attach(
                                id: widget.thisTodoID,
                                attachmentPath: pickedImage!.path);

                            attached ? getDetail() : {};
                          },
                        ),
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
                            edited ? getDetail() : {};
                          },
                        ),
                      ],
                    ),
                    const CustomDivider(),
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
                              builder: (context) =>
                                  DeleteAlert(id: widget.thisTodoID));

                          if (deleted) {
                            Navigator.pop(context, true);
                          }
                        }),
                    const CustomDivider(),
                  ],
                ),
              ),
      ),
    );
  }
}
