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

import 'dart:developer';
import 'package:abc_bloc_inspector/src/abc_bloc_constants.dart';
import 'package:abc_bloc_inspector/src/state_replay_bloc.dart';
import 'package:flutter/foundation.dart';

// Class to manage Bloc bindings
class AbcBlocBinding {
  // Private constructor
  AbcBlocBinding._();

  // Singleton instance for debug mode
  static final debugInstance =
      kDebugMode ? AbcBlocBinding._() : throw UnsupportedError('Cannot use AbcBlocBinding in release mode');

  // Map to store Bloc instances
  final Map<String, StateReplayBloc<dynamic, dynamic>> _blocs = {};
  // Getter for blocs map
  Map<String, StateReplayBloc<dynamic, dynamic>> get blocs => _blocs;

  // Method to add a Bloc
  void addBloc(StateReplayBloc<dynamic, dynamic> bloc) {
    final blocName = bloc.runtimeType.toString();
    if (!_blocs.containsKey(blocName)) {
      _blocs[bloc.runtimeType.toString()] = bloc;
    }

    // Post an event to notify that the bloc list has changed
    postEvent(AbcBlocConstants.blocListChanged, {});
  }

  // Method to remove a Bloc
  void removeBloc(String name) {
    _blocs.remove(name);

    // Post an event to notify that the bloc list has changed
    postEvent(AbcBlocConstants.blocListChanged, {});
  }
}
