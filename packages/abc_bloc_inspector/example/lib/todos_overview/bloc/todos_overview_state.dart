part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  factory TodosOverviewState.fromJson(Map<String, dynamic> json) =>
      TodosOverviewState(
        status: TodosOverviewStatus.values
            .firstWhere((e) => e.name == json['status']),
        todos: (json['todos'] as List)
            .map((todo) => Todo.fromJson(todo as Map<String, dynamic>))
            .toList(),
        filter:
            TodosViewFilter.values.firstWhere((e) => e.name == json['filter']),
        lastDeletedTodo: json['lastDeletedTodo'] != null
            ? Todo.fromJson(json['lastDeletedTodo'] as Map<String, dynamic>)
            : null,
      );

  final TodosOverviewStatus status;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) =>
      TodosOverviewState(
        status: status != null ? status() : this.status,
        todos: todos != null ? todos() : this.todos,
        filter: filter != null ? filter() : this.filter,
        lastDeletedTodo:
            lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
      );

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'todos': todos.map((todo) => todo.toJson()).toList(),
        'filter': filter.name,
        'lastDeletedTodo': lastDeletedTodo?.toJson(),
      };

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedTodo,
      ];
}
