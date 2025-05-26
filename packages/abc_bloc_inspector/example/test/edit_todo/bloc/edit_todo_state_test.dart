// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';
import 'package:todos_repository/todos_repository.dart';

void main() {
  group('EditTodoState', () {
    final mockInitialTodo = Todo(
      id: '1',
      title: 'title 1',
      description: 'description 1',
    );

    EditTodoState createSubject({
      Todo? initialTodo,
      String title = '',
      String description = '',
    }) =>
        EditTodoStateSuccess(
          initialTodo: initialTodo,
          title: title,
          description: description,
        );

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('isNewTodo returns true when a new todo is being created', () {
      expect(
        createSubject(
              initialTodo: null,
            ).initialTodo ==
            null,
        isTrue,
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            initialTodo: null,
            title: '',
            description: '',
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            initialTodo: mockInitialTodo,
            title: 'title',
            description: 'description',
          ),
          equals(
            createSubject(
              initialTodo: mockInitialTodo,
              title: 'title',
              description: 'description',
            ),
          ),
        );
      });
    });
  });
}
