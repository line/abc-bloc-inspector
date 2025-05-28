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

// ignore_for_file: avoid_print, avoid_dynamic_calls, empty_catches, avoid_catches_without_on_clauses
import 'dart:developer';
import 'package:abc_bloc_inspector/abc_bloc_inspector.dart';
import 'package:bloc/bloc.dart';

// Observer class to monitor state changes in Bloc
class AbcBlocInspectorObserver extends BlocObserver {
  factory AbcBlocInspectorObserver({List? plugins}) {
    _instance ??= AbcBlocInspectorObserver._internal(plugins);
    return _instance!;
  }

  // Factory constructor to return the singleton instance
  AbcBlocInspectorObserver._internal(this._plugins);

  // Singleton instance
  static AbcBlocInspectorObserver? _instance;

  final List? _plugins;

  // Method to post Bloc events
  void _postBlocEvent(
    String type,
    BlocBase<dynamic> bloc, [
    Map<String, dynamic>? additionalData,
  ]) {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'type': type,
      'blocName': bloc.runtimeType.toString(),
      ...?additionalData,
    };

    try {
      // Post the event
      postEvent(AbcBlocConstants.blocEvent, logData);

      for (final plugin in _plugins ?? []) {
        plugin.log(logData);
      }
    } catch (e) {
      // Handle errors during event posting
      print('Error posting event: $e');
    }
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    // Post event on Bloc creation
    _postBlocEvent('CREATE', bloc);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    // Convert current state to JSON
    final jsonCurrentData = _safeToJson(change.currentState);
    // Convert next state to JSON
    final jsonNextData = _safeToJson(change.nextState);
    // Current state name
    final currentStateName = _safeTypeName(change.currentState);
    // Next state name
    final nextStateName = _safeTypeName(change.nextState);

    _postBlocEvent('CHANGE', bloc, {
      'currentState': currentStateName,
      'nextState': nextStateName,
      'currentStateData': jsonCurrentData,
      'nextStateData': jsonNextData,
    });
    // Post event on state change
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, dynamic event) {
    super.onEvent(bloc, event);

    // Convert event data to JSON
    final jsonEventData = _safeToJson(event);
    // Event name
    final eventName = _safeTypeName(event);

    _postBlocEvent('EVENT', bloc, {
      'eventName': eventName,
      'eventData': jsonEventData,
    });
    // Post event on event occurrence
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    _postBlocEvent('ERROR', bloc, {
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
    });
    // Post event on error occurrence
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    // Post event on Bloc closure
    _postBlocEvent('CLOSE', bloc);
  }

  Map<String, dynamic> _safeToJson(dynamic object) {
    try {
      return object.toJson() as Map<String, dynamic>;
    } catch (e) {
      return {}; // Return empty map on conversion failure
    }
  }

  // Method to safely convert an object to JSON
  String _safeTypeName(dynamic object) {
    try {
      return object.$type as String;
    } catch (e) {
      return object.runtimeType.toString(); // Return runtime type on failure
    }
  }
}
