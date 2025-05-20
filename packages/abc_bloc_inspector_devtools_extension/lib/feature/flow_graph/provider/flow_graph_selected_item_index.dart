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

part 'flow_graph_selected_item_index.g.dart';

// Provider class to manage the selected item index of the flow graph by TimeLine view.
@riverpod
class FlowGraphSelectedItemIndex extends _$FlowGraphSelectedItemIndex {
  @override
  int build() => -1;

  // Method to update the selected item's index state of the flow graph.
  void setSelectedItemIndex(int index) {
    state = index;
  }
}
