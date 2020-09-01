import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo.dart';
import '../Database/database_helper.dart';

abstract class TodoEvent {}

class LoadTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  Map<String, dynamic> _todo;
  AddTodoEvent(this._todo);

  Map<String, dynamic> get todo => _todo;
}

class DeleteTodoEvent extends TodoEvent {
  int _id;
  DeleteTodoEvent(this._id);

  int get id => _id;
}

class UpdateTodoEvent extends TodoEvent {
  Todo _todo;
  UpdateTodoEvent(this._todo);

  Todo get todo => _todo;
}

abstract class TodoState {}

class InitState extends TodoState {}

class TodoLoadedState extends TodoState {
  List<Todo> _todos;
  TodoLoadedState(this._todos);

  List<Todo> get todos => _todos;
}

class LoadingTodoState extends TodoState {}

class TodoNotLoading extends TodoState {}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(InitState());

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is AddTodoEvent) {
      yield LoadingTodoState();
      int id = await DatabaseHelper.instance.insert(event.todo);
      List<Todo> todos = await DatabaseHelper.instance.queryAll();
      yield TodoLoadedState(todos);
    } else if (event is LoadTodoEvent) {
      yield LoadingTodoState();
      List<Todo> todos = await DatabaseHelper.instance.queryAll();
      yield TodoLoadedState(todos);
    } else if (event is DeleteTodoEvent) {
      await DatabaseHelper.instance.delete(event.id);
    } else if (event is UpdateTodoEvent) {
      await DatabaseHelper.instance.update(event.todo.toMap());
      List<Todo> todos = await DatabaseHelper.instance.queryAll();
      yield TodoLoadedState(todos);
    }
  }
}
