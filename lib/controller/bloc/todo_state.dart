part of 'todo_bloc.dart';


abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoInitial extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoLoadedState extends TodoState {
  final List<Task> todos;

  const TodoLoadedState(this.todos);

  @override
  List<Object?> get props => [todos];
}