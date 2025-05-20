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

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bloc_log_item.freezed.dart';
part 'bloc_log_item.g.dart';

// Represents a log item for Bloc operations.
@freezed
sealed class BlocLogItem with _$BlocLogItem {
  BlocLogItem._();

  // Factory constructor for creating a BlocCreateLogItem.
  factory BlocLogItem.create({
    int? index,
    required DateTime timestamp,
    required String blocName,
  }) = BlocCreateLogItem;

  // Factory constructor for creating a BlocEventLogItem.
  factory BlocLogItem.event({
    int? index,
    required DateTime timestamp,
    required String blocName,
    required String eventName,
    required Map<String, dynamic> eventData,
  }) = BlocEventLogItem;

  // Factory constructor for creating a BlocChangeLogItem.
  factory BlocLogItem.change({
    int? index,
    required DateTime timestamp,
    required String blocName,
    required String currentState,
    required String nextState,
    required Map<String, dynamic> currentStateData,
    required Map<String, dynamic> nextStateData,
  }) = BlocChangeLogItem;

  // Factory constructor for creating a BlocErrorLogItem.
  factory BlocLogItem.error({
    int? index,
    required DateTime timestamp,
    required String blocName,
    required Map<String, dynamic> error,
  }) = BlocErrorLogItem;

  // Factory constructor for creating a BlocCloseLogItem.
  factory BlocLogItem.close({
    int? index,
    required DateTime timestamp,
    required String blocName,
  }) = BlocCloseLogItem;

  // Factory constructor for creating a BlocLogItem from JSON.
  factory BlocLogItem.fromJson(Map<String, dynamic> json) =>
      _$BlocLogItemFromJson(json);
}

// Extension to get the type of BlocLogItem as a string.
extension BlocLogItemExtension on BlocLogItem {
  String getTypeString() {
    switch (this) {
      case BlocCreateLogItem():
        return 'CREATE';
      case BlocEventLogItem():
        return 'EVENT';
      case BlocChangeLogItem():
        return 'CHANGE';
      case BlocErrorLogItem():
        return 'ERROR';
      case BlocCloseLogItem():
        return 'CLOSE';
    }
  }

  bool isSearchResult(String searchWord) =>
      toString().toLowerCase().contains(searchWord.toLowerCase());
}

// Enum representing different types of Bloc log nodes.
enum NodeType {
  create,
  event,
  change,
  error,
  close;

  // Converts a string to a NodeType.
  static NodeType? fromString(String value) {
    switch (value) {
      case 'CREATE':
        return NodeType.create;
      case 'EVENT':
        return NodeType.event;
      case 'CHANGE':
        return NodeType.change;
      case 'ERROR':
        return NodeType.error;
      case 'CLOSE':
        return NodeType.close;
      default:
        return null;
    }
  }
}
