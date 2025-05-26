import 'package:abc_bloc_inspector/abc_bloc_inspector.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_repository/todos_repository.dart';

part 'edit_todo_bloc.freezed.dart';
part 'edit_todo_bloc.g.dart';
part 'edit_todo_event.dart';
part 'edit_todo_state.dart';

class EditTodoBloc extends StateReplayBloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          EditTodoState.success(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            description: initialTodo?.description ?? '',
          ),
          stateConverter: EditTodoState.fromJson,
        ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoSubmitted>(_onSubmitted);
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(
      EditTodoState.loading(
        title: state.title,
        description: state.description,
      ),
    );

    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(
        EditTodoState.submitted(
          title: todo.title,
          description: todo.description,
        ),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      emit(
        EditTodoState.failure(
          title: state.title,
          description: state.description,
          errorMessage: 'submit failed: $e',
        ),
      );
    }
  }
}
