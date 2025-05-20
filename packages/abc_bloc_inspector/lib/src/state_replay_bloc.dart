/// Copyright 2025 LY Corporation
///
/// LINE Corporation licenses this file to you under the Apache License,
/// version 2.0 (the "License"); you may not use this file except in compliance
/// with the License. You may obtain a copy of the License at:
///
///   https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
/// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
/// License for the specific language governing permissions and limitations
/// under the License.
library;

import 'package:abc_bloc_inspector/src/abc_bloc_binding.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

/// {@template state_replay_bloc}
/// A custom [StateReplayBloc] can be created by extending [StateReplayBloc].
///
/// ```dart
/// abstract class CounterEvent {}
/// class CounterIncrementPressed extends CounterEvent {}
///
/// class CounterBloc extends StateReplayBloc<CounterEvent, int> {
///   CounterBloc() : super(0) {
///     on<CounterIncrementPressed>((event, emit) => emit(state + 1));
///   }
/// }
/// ```
///
/// Then the built-in `undo` and `redo` operations can be used.
///
/// ```dart
/// final bloc = CounterBloc();
///
/// bloc.add(CounterIncrementPressed());
///
/// bloc.applyState({'value': 1});
/// ```
///
/// The undo/redo history can be destroyed at any time by calling `clear`.
///
/// See also:
///
/// * [Bloc] for information about the [StateReplayBloc] superclass.
///
/// {@endtemplate}
abstract class StateReplayBloc<Event, State> extends Bloc<Event, State> with StateReplayBlocMixin<Event, State> {
  // Constructor for StateReplayBloc with an optional converter.
  StateReplayBloc(
    super.initialState, {
    required State Function(Map<String, dynamic> data) stateConverter,
  }) {
    _converter = stateConverter;

    if (kDebugMode) {
      AbcBlocBinding.debugInstance.addBloc(this);
    }
  }
}

// A mixin which enables `undo` and `redo` operations for [Bloc] classes.
mixin StateReplayBlocMixin<Event, State> on Bloc<Event, State> {
  late final State Function(Map<String, dynamic> data) _converter;

  set converter(
    State Function(Map<String, dynamic> data) handler,
  ) {
    _converter = handler;
  }

  @override
  Future<void> close() async {
    if (kDebugMode) {
      AbcBlocBinding.debugInstance.removeBloc(runtimeType.toString());
    }

    await super.close();
  }

  // Applies a new state based on the provided state data.
  void applyState(Map<String, dynamic> stateData) {
    if (!kDebugMode) {
      throw UnsupportedError('Cannot use applyState method in release mode');
    }

    final newState = _converter.call(stateData);
    // ignore: invalid_use_of_visible_for_testing_member
    emit(newState);
  }
}
