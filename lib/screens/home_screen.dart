import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learn_hive/boxes/boxes.dart';
import 'package:learn_hive/model/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hive Notes App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Tooltip(
                                  message: data[index].title.toString(),
                                  child: Text(
                                    data[index].title.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          // const Spacer(),
                          CircleAvatar(
                            child: IconButton(
                                onPressed: () {
                                  delete(data[index]);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                )),
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          CircleAvatar(
                            child: IconButton(
                                onPressed: () {
                                  _editDialog(data[index], data[index].title, data[index].description);
                                },
                                icon: const Icon(
                                  Icons.update,
                                  color: Colors.deepPurpleAccent,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Tooltip(
                        message: data[index].description.toString(),
                          child: Text(data[index].description.toString())
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(
          Icons.add_circle,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            actions: [
              TextButton(
                  onPressed: () {
                    final note = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);

                    final box = Boxes.getData();
                    box.add(note);

                    note.save();

                    // print(box);

                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              )
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Title",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Description",
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void delete(NotesModel notesModel) async{
    await notesModel.delete();
  }


  Future<void> _editDialog(NotesModel notesModel, String title, String description) async {

    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Notes"),
            actions: [
              TextButton(
                  onPressed: () async{

                    notesModel.title = titleController.text.toString();
                    notesModel.description = descriptionController.text.toString();
                    await notesModel.save();

                    Navigator.pop(context);
                  },
                  child: const Text("Edit")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              )
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Title",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Description",
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
