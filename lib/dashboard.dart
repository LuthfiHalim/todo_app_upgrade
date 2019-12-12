import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statefulwidget_loginpage_luthfi/addtodo.dart';
import 'package:flutter_statefulwidget_loginpage_luthfi/detailpage.dart';
import 'package:flutter_statefulwidget_loginpage_luthfi/pages.dart';
import 'package:flutter_statefulwidget_loginpage_luthfi/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'box_widget.dart';
import 'detailpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _InputData {
  String deskripsi = '';
  int urutan;
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  Future<FormData> photo({path, name}) async {
    return FormData.fromMap({
      "name": name,
      "favorite": false,
      "photo": await MultipartFile.fromFile(path, filename: "user-photo")
    });
  }

  addNewTodoFireStore(String title, String desc) async {
    Firestore.instance
        .collection('todo')
        .document()
        .setData({'title': title, 'description': desc, 'status': false});
  }

  handleToDo(val, path) {
    Todo.postTodo(photo(path: path, name: val));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget bodyChoice(index) {
    switch (index) {
      case 0:
        return Home();

      case 1:
        return Request();

      case 2:
        return History();

      case 3:
        return Logout();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Kerjaan')),
      body: bodyChoice(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        backgroundColor: Colors.blue,
        onPressed: () {
          //addNew();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddTodoFireStore(fungsi: addNewTodoFireStore)));
        },
        icon: Icon(Icons.work),
        label: Text('Add'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Request'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('MyProfile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Logout extends StatelessWidget {
  logout(context) async {
    final simpanData = await SharedPreferences.getInstance();
    simpanData.remove('token');
    Navigator.pushReplacementNamed(context, Pages.Login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Logout'),
          onPressed: () {
            logout(context);
          },
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('History'),
          onPressed: () {},
        ),
      ),
    );
  }
}

class Request extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Request'),
          onPressed: () {},
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHome();
  }
}

void addNew() {
  Firestore.instance
      .collection('todo')
      .document()
      .setData({'title': 'berobat', 'description': 'sakit', 'status': true});
}

void performQuery() {
  Firestore.instance
      .collection('talks')
      .where("topic", isEqualTo: "flutter")
      .snapshots()
      .listen((data) => data.documents.forEach((doc) => print(doc["title"])));
}

void getSpecificDocument() {
  Firestore.instance
      .collection('talks')
      .document('document-name')
      .get()
      .then((DocumentSnapshot ds) {
    // use ds as a snapshot
  });
}

void runningTransaction() {
  final DocumentReference postRef = Firestore.instance.document('posts/123');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(postRef,
          <String, dynamic>{'likesCount': postSnapshot.data['likesCount'] + 1});
    }
  });
}

class StateHome extends State<Home> {
  List<Todo> kerjaan;
  bool checkAll = false;
  String filtered = "total";
  _InputData data = _InputData();
  Firestore firestore;

  void getTodos() async {
    //var response = await Todo.getTodos();
    var data = await TodoFireStore.initTodoFireStore();
    setState(() {
      firestore = data;
      //kerjaan = response;
      //loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    print('init');
    getTodos();
  }

  editTitle(String title, int index, String documentID) async {
    await Firestore.instance
        .collection('todo')
        .document(documentID)
        .updateData(<String, dynamic>{
      'title': title,
    });
  }

  editDescription(String desc, int index, String documentID) async {
    await Firestore.instance
        .collection('todo')
        .document(documentID)
        .updateData(<String, dynamic>{
      'description': desc,
    });
  }

  removeWidget(int index, String documentID) async {
    await Firestore.instance.collection('todo').document(documentID).delete();
  }

  clickCheckBox(bool status, int index, String documentID) async {
    await Firestore.instance
        .collection('todo')
        .document(documentID)
        .updateData(<String, dynamic>{
      'status': status,
    });
  }

  int jumlahChecked() {
    int jumlah = 0;
    setState(() {
      for (var item in kerjaan) {
        if (item.checked) {
          jumlah++;
        }
      }
    });
    return jumlah;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('todo').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        int done = 0;
        int total = snapshot.data.documents.length == null
            ? 0
            : snapshot.data.documents.length;
        for (var i = 0; i < total; i++) {
          String data = snapshot.data.documents[i].documentID;
          print(data);
          if (snapshot.data.documents[i]['status']) {
            done++;
          }
        }
        int ongoing = total - done;
        return Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Box(
                      status: 'Done',
                      warna: Colors.green,
                      jumlah: done,
                      icon: Icon(Icons.check),
                    ),
                    Box(
                      status: 'Kerjain',
                      warna: Colors.red,
                      jumlah: ongoing,
                      icon: Icon(Icons.calendar_today),
                    ),
                    Box(
                      status: 'Total',
                      warna: Colors.black,
                      jumlah: total,
                      icon: Icon(Icons.people),
                    ),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Check All'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Checkbox(
                      value: checkAll,
                      onChanged: (val) {
                        setState(() {
                          checkAll = val;
                        });
                        for (var i = 0; i < total; i++) {
                          clickCheckBox(
                              val, i, snapshot.data.documents[i].documentID);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('Delete Checked'),
                  ),
                  Expanded(
                    flex: 3,
                    child: RaisedButton.icon(
                      key: Key('value'),
                      elevation: 0,
                      label: Expanded(
                        child: Card(),
                      ),
                      color: Colors.transparent,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          checkAll = false;
                        });
                        for (var i = 0; i < total; i++) {
                          removeWidget(
                              i, snapshot.data.documents[i].documentID);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: total == 0
                  ? Text(
                      '''Tambahkan Kerjaan!



          ==>''',
                      style: TextStyle(color: Colors.blue, fontSize: 48),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: total,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              removeWidget(index,
                                  snapshot.data.documents[index].documentID);
                            },
                            child: Card(
                              elevation: 10,
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                                description: snapshot
                                                        .data.documents[index]
                                                    ['description'],
                                                index: index,
                                                fungsi: editDescription,
                                                documentID: snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID,
                                              )));
                                },
                                onLongPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailScreenEdit(
                                                title: snapshot.data
                                                    .documents[index]['title'],
                                                index: index,
                                                documentID: snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID,
                                                fungsi: editTitle,
                                              )));
                                },
                                leading: Icon(Icons.work),
                                trailing: Checkbox(
                                  value: snapshot.data.documents[index]
                                      ['status'],
                                  onChanged: (val) {
                                    clickCheckBox(
                                        val,
                                        index,
                                        snapshot
                                            .data.documents[index].documentID);
                                  },
                                ),
                                title: snapshot.data.documents[index]['status']
                                    ? Text(
                                        '${snapshot.data.documents[index]['title']}',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.green))
                                    : Text(
                                        '${snapshot.data.documents[index]['title']}',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.red)),
                              ),
                            ));
                      },
                    ),
            )
          ],
        );
      },
    );
  }
}
