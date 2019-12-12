import 'package:flutter/material.dart';
//import 'package:flutter_statefulwidget_loginpage_luthfi/todo.dart';


class DetailScreen extends StatelessWidget {
  
  final String description;
  final fungsi;
  final int index;
  final String documentID;
  DetailScreen({Key key, @required this.description, @required this.fungsi, @required this.index, @required this.documentID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Deskripsi'),
        ),
      body: TextFormField(
        initialValue: description,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
        hintText: 'nyuci baju pake mesin cuci', labelText: 'Deskripsi'),
        onFieldSubmitted: (desc) {
            fungsi(desc, index, documentID);
            Navigator.pop(context);
          },
      ),
    );
  }
}

class DetailScreenEdit extends StatelessWidget {
  final String title;
  final fungsi;
  final int index;
  final String documentID;
  DetailScreenEdit({Key key,@required this.title, @required this.fungsi, @required this.index, @required this.documentID}): super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Judul Kerjaan')
      ),
      body: TextFormField(
        initialValue: title,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
        hintText: 'Nyuci Baju', labelText: 'Judul Kerjaan'),

         onFieldSubmitted: (title) {
            fungsi(title, index, documentID);
            Navigator.pop(context);
          },
      ),
    );
  }
}