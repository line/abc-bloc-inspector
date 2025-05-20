part of 'edit_todo_bloc.dart';

typedef JsonMap = Map<String, dynamic>;

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

final class EditTodoState extends Equatable {
  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
  });

  factory EditTodoState.fromJson(Map<String, dynamic> json) => EditTodoState(
        status: EditTodoStatus.values.firstWhere(
          (e) => e.toString() == 'EditTodoStatus.${json['status']}',
        ),
        initialTodo: json['initialTodo'] != null
            ? Todo.fromJson(json['initialTodo'] as JsonMap)
            : null,
        title: json['title'] as String,
        description: json['description'] as String,
      );

  final EditTodoStatus status;
  final Todo? initialTodo;
  final String title;
  final String description;

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    Todo? initialTodo,
    String? title,
    String? description,
  }) =>
      EditTodoState(
        status: status ?? this.status,
        initialTodo: initialTodo ?? this.initialTodo,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  @override
  List<Object?> get props => [status, initialTodo, title, description];

  Map<String, dynamic> toJson() => {
        'status': status.toString().split('.').last,
        'initialTodo': initialTodo?.toJson(),
        'title': title,
        'description': description,
      };
}
