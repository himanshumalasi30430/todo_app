import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/Database/database_helper.dart';
import '../models/todo.dart';

class Favourite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FavouriteItemList();
  }
}

class FavouriteItemList extends StatefulWidget {
  @override
  _FavouriteItemListState createState() => _FavouriteItemListState();
}

class _FavouriteItemListState extends State<FavouriteItemList> {
  List<Todo> _todos = [];

  loadTodos() async {
    var todos = await DatabaseHelper.instance.queryAllFavourite();
    setState(() {
      _todos = todos;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index].title),
                  subtitle: Text(_todos[index].subtitle),
                  trailing: Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                );
              })),
    );
  }
}
