part of 'edit_todo_bloc.dart';

@Freezed(fromJson: true, toJson: true)
abstract class EditTodoState with _$EditTodoState {
  const factory EditTodoState.loading({
    Todo? initialTodo,
    @Default('') String title,
    @Default('') String description,
  }) = EditTodoStateLoading;
  const factory EditTodoState.success({
    Todo? initialTodo,
    @Default('') String title,
    @Default('') String description,
  }) = EditTodoStateSuccess;
  const factory EditTodoState.submitted({
    Todo? initialTodo,
    @Default('') String title,
    @Default('') String description,
  }) = EditTodoStateSubmitted;
  const factory EditTodoState.failure({
    Todo? initialTodo,
    @Default('') String title,
    @Default('') String description,
    required String errorMessage,
  }) = EditTodoStateFailure;

  const EditTodoState._();

  factory EditTodoState.fromJson(Map<String, dynamic> json) =>
      _$EditTodoStateFromJson(json);
}
