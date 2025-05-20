part of 'edit_todo_bloc.dart';

sealed class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson();
}

final class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];

  @override
  Map<String, dynamic> toJson() => {
        'event': 'EditTodoTitleChanged',
        'title': title,
      };
}

final class EditTodoDescriptionChanged extends EditTodoEvent {
  const EditTodoDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];

  @override
  Map<String, dynamic> toJson() => {
        'event': 'EditTodoDescriptionChanged',
        'description': description,
      };
}

final class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();

  @override
  Map<String, dynamic> toJson() => {
        'event': 'EditTodoSubmitted',
      };
}

final class EditTodoBlocEventForDebug extends EditTodoEvent {
  const EditTodoBlocEventForDebug(this.stateData);

  final dynamic stateData;

  @override
  Map<String, dynamic> toJson() => {
        'event': 'EventForDebug',
        'state': stateData,
      };
}
