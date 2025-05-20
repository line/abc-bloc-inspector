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

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flow_graph_scroll_lock.g.dart';

// A Riverpod provider class to manage the scroll lock state of the flow graph.
@riverpod
class FlowGraphScrollLock extends _$FlowGraphScrollLock {
  // Initializes the state with a default value of false (unlocked).
  @override
  bool build() => false;

  // Sets the scroll lock state.
  //
  // [isLocked] - A boolean value indicating whether the scroll is locked or not.
  void setLock({required bool isLocked}) {
    state = isLocked;
  }
}
