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

import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flow_graph_scroll_offset.g.dart';

// A Riverpod provider class to manage the scroll offsets of the flow graph.
@riverpod
class FlowGraphScrollOffset extends _$FlowGraphScrollOffset {
  // Initializes the state with an empty map.
  @override
  Map<String, Offset> build() => {};

  // Sets the offset for a given key.
  void setOffset(String key, Offset offset) {
    state = {...state, key: offset};
  }

  // Clears all stored offsets.
  void clearAllOffset() {
    state = {};
  }
}
