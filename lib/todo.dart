import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';

class Todo {
  final String name;
  final String address;
  final int id;
  final String imagepath;

  bool checked = false;

  Todo(this.name, this.address, this.id, this. checked, this.imagepath);

  Todo.fromJSON(Map<String,dynamic> response)
      : name = response['name'],
        address = response['address'],
        checked = response['favorite'],
        id = response['id'],
        imagepath = response['image_url']
        ;
  
  static getTodos() async {
    var response = 
        await Dio().get("https://address-book-exp-api.herokuapp.com/users");
    
    List<Todo> todos = (response.data['data'] as List).map((item) => Todo.fromJSON(item)).toList();

    return todos;
  }

  static postTodo(data) async {
    var response = await Dio().post("https://address-book-exp-api.herokuapp.com/users", data: await data);
    return response;
  }
  static patchTodo(data, id) async {
    var response = await Dio().patch("https://address-book-exp-api.herokuapp.com/users/$id", data: data);
    return response;
  }
  static deleteTodos(id) async {
    var response = await Dio().delete("https://address-book-exp-api.herokuapp.com/users/$id");
    return response;
  }
}

class TodoFireStore{
  final String title;
  final String description;
  bool status;

  TodoFireStore(this.title, this.description, this.status);

  TodoFireStore.fromJSON(Map<String,dynamic> response)
      : title = response['title'],
        description = response['description'],
        status = response['status']
        ;
  
  static initTodoFireStore() async {
    final FirebaseApp todoApp = await FirebaseApp.configure(
      name: 'init',
      options: const FirebaseOptions(
        googleAppID: '1:763914117284:android:f8bd43c53cc5d282848631',
        gcmSenderID: '763914117284',
        apiKey: 'AIzaSyBmHY0ZdJjzXFSwtJRrWINuF8KqUf_f9bc',
        projectID: 'todo-app-8e801',
      ),
    );
    Firestore data = Firestore(app: todoApp);
    return data;
  }

  static getTodosFireStore(){
    
  }
}

