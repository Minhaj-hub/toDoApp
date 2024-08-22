import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist/model/task.dart';

import '../../services/database_services.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseServices _databaseServices;

  TodoBloc(this._databaseServices) : super(TodoInitial()) {
    on<LoadTodosEvent>((event, emit) async {
      List<Task> todoList;

      if (event.flag == 'Priority') {
        if (event.keyword == 'All') {
          todoList = await _databaseServices.loadAllTodos();
        } else {
          todoList =
              await _databaseServices.filterTodosByPrority(event.keyword);
        }
      } else if (event.flag == 'DueDate') {
        todoList = await _databaseServices.filterTodosByDueDate(event.keyword);
      } else if (event.flag == 'TaskName') {
        todoList = await _databaseServices.filterTodosByTaskName(event.keyword);
      }  else {
        todoList = [];
      }

      emit(TodoLoadedState(todoList));
    });

    on<CreateNewTodoEvent>((event, emit) async {
      await _databaseServices.createNewTodo(
        id: event.id,
        title: event.title,
        desc: event.description,
        priority: event.priority,
        dueDate: event.dueDate,
        dueTime: event.dueTime,
        isCompleted: event.isCompleted == true ? 1 : 0,
      );
      add(const LoadTodosEvent());
    });

    on<UpdateTodoEvent>((event, emit) async {
      await _databaseServices.updateTodo(
        id: event.id,
        newTitle: event.title,
        newDesc: event.description,
        newPriority: event.priority,
        newDueDate: event.dueDate,
        newDueTime: event.dueTime,
        newIsCompleted: event.isCompleted == true ? 1 : 0,
      );
      add(const LoadTodosEvent());
    });

    on<DeleteTodoEvent>((event, emit) async {
      await _databaseServices.deleteTodo(todoId: event.todoId);
      add(const LoadTodosEvent());
    });

    on<CompleteTodoEvent>((event, emit) async {
      await _databaseServices.completeTodo(todoId: event.todoId);
      add(const LoadTodosEvent());
    });
  }
}
