import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_sqflite/bloc/todo_bloc.dart';
import 'package:todo_app_sqflite/screens/favourite.dart';
import 'models/todo.dart';

void main() {
  runApp(MaterialApp(
    title: 'Todo App',
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String title = '';
  String subtitle = '';
  @override
  void initState() {
    super.initState();
    var provider = BlocProvider.of<TodoBloc>(context);
    provider.add(LoadTodoEvent());
  }

  @override
  Widget build(BuildContext context) {
    var provider = BlocProvider.of<TodoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Favourite()));
            },
          )
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is InitState) {
            return Text('Init state is loaded');
          } else if (state is LoadingTodoState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoadedState) {
            return Container(
              child: ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(state.todos[index].id),
                      onDismissed: (direction) {
                        provider.add(DeleteTodoEvent(state.todos[index].id));
                      },
                      child: ListTile(
                        title: Text(state.todos[index].title),
                        subtitle: Text(state.todos[index].subtitle),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite),
                          color: state.todos[index].isFavorite
                              ? Colors.pink
                              : Colors.grey,
                          onPressed: () {
                            if (state.todos[index].isFavorite) {
                              Todo todo = state.todos[index];
                              todo.isFavorite = false;
                              provider.add(UpdateTodoEvent(todo));
                            } else {
                              Todo todo = state.todos[index];
                              todo.isFavorite = true;
                              provider.add(UpdateTodoEvent(todo));
                            }
                          },
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Center(child: Text('Error while loading...'));
          }
        },
      ),
      floatingActionButton: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                //provider.add(AddTodoEvent());
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Create a Todo'),
                    content: Container(
                      height: 150,
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                title = value;
                              },
                              decoration: InputDecoration(hintText: 'Title'),
                            ),
                            TextFormField(
                              onChanged: (value) {
                                subtitle = value;
                              },
                              decoration: InputDecoration(hintText: 'Subtitle'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Submit'),
                        onPressed: () {
                          Todo todo = Todo(
                              title: title,
                              subtitle: subtitle,
                              isFavorite: false);
                          provider.add(AddTodoEvent(todo.toMap()));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
                // Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
