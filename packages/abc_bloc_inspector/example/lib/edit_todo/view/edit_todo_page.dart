import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:todos_repository/todos_repository.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<void> route({Todo? initialTodo}) => MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => EditTodoBloc(
            todosRepository: context.read<TodosRepository>(),
            initialTodo: initialTodo,
          ),
          child: const EditTodoPage(),
        ),
      );

  @override
  Widget build(BuildContext context) =>
      BlocListener<EditTodoBloc, EditTodoState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is EditTodoStateSubmitted) {
            Navigator.of(context).pop();
          } else if (state is EditTodoStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: const EditTodoView(),
      );
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTodoBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.initialTodo == null
              ? l10n.editTodoAddAppBarTitle
              : l10n.editTodoEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editTodoSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: state is EditTodoStateLoading
            ? null
            : () => context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
        child: state is EditTodoStateLoading
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const _TitleField(),
                const _DescriptionField(),
                Text(state.title),
                Text(state.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !(state is EditTodoStateLoading),
        labelText: l10n.editTodoTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !(state is EditTodoStateLoading),
        labelText: l10n.editTodoDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}
