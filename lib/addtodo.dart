import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statefulwidget_loginpage_luthfi/pages.dart';

class AddTodoFireStore extends StatelessWidget {
  final fungsi;

  var _titleController = TextEditingController();
  var _descController = TextEditingController();

  AddTodoFireStore({@required this.fungsi});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add ToDo'),
        ),
        body: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'judul kerjaan', labelText: 'Title'),
              onFieldSubmitted: (input) {},
            ),
            TextFormField(
              controller: _descController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'nyuci baju pake mesin cuci',
                  labelText: 'Deskripsi'),
              onFieldSubmitted: (desc) {},
            ),
            RaisedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                fungsi(_titleController.text, _descController.text);
                Navigator.pop(context);
              },
              label: Card(),
            )
          ],
        ));
  }
}

class AddTodo extends StatefulWidget {
  final handleToDo;

  const AddTodo(this.handleToDo);

  @override
  AddTodoState createState() {
    return AddTodoState(this.handleToDo);
  }
}

class AddTodoState extends State<AddTodo> {
  final handleToDo;
  AddTodoState(this.handleToDo);

  CameraDescription firstCamera;
  String path;

  final todoController = TextEditingController();

  final descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCamera();
  }

  getCamera() async {
    final cameras = await availableCameras();
    setState(() {
      firstCamera = cameras.first;
    });
  }

  navigateAndGetPhoto() async {
    final result = await Navigator.pushNamed(context, Pages.Camera,
        arguments: {"camera": firstCamera});

    setState(() {
      path = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Kerjaan')),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              TextField(
                controller: todoController,
                decoration: InputDecoration(helperText: 'Tambah Kerjaan'),
              ),
              Container(
                child: path != null
                    ?
                    // ListView(
                    //   children: <Widget>[
                    Image.file(File(path))
                    //   ],
                    // )
                    : IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          navigateAndGetPhoto();
                        },
                      ),
              ),
              RaisedButton.icon(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                  label: Expanded(
                    child: Card(),
                  ))
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.work),
        label: Text('Add'),
        onPressed: () {
          handleToDo(todoController.text, path);
          Navigator.pop(context);
        },
      ),
    );
  }
}
