part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class LoadTodosEvent extends TodoEvent {
  final String keyword,flag;
  const LoadTodosEvent({this.keyword = 'All',this.flag = 'Priority'});

  @override
  List<Object?> get props => [];
}

class CreateNewTodoEvent extends TodoEvent {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final String dueTime;
  final bool isCompleted;

  const CreateNewTodoEvent(
      {required this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.dueDate,
      required this.dueTime,
      required this.isCompleted});

  @override
  List<Object?> get props =>
      [id, title, description, priority, dueDate, dueTime, isCompleted];
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final String dueTime;
  final bool isCompleted;

  const UpdateTodoEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.dueTime,
    required this.isCompleted,
  });

  @override
  List<Object?> get props =>
      [id, title, description, priority, dueDate, dueTime, isCompleted];
}

class DeleteTodoEvent extends TodoEvent {
  final String todoId;

  const DeleteTodoEvent({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}

class CompleteTodoEvent extends TodoEvent {
  final String todoId;

  const CompleteTodoEvent({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}
