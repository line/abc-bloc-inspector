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

import 'package:abc_bloc_inspector_devtools_extension/feature/home/model/selected_tabs_state.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_tabs.g.dart';

// A Riverpod provider that manages the state of selected tabs.
@riverpod
class SelectedTabs extends _$SelectedTabs {
  // Initializes the state with an empty set of selected tabs.
  @override
  SelectedTabsState build() => SelectedTabsState();

  Set<String> getSelectedTabs() {
    final mode = ref.read(modeProvider);

    return mode == ModeType.single ? state.single : state.multi;
  }

  // Toggles the selection of a tab based on the current mode.
  // If the mode is single, only the given tab will be selected.
  // If the mode is multiple, the given tab will be added or removed from the selection.
  void toggleSelectedTab(String tabName) {
    final mode = ref.read(modeProvider);

    if (mode == ModeType.single) {
      state = state.copyWith(single: {tabName});
    } else {
      if (state.multi.contains(tabName)) {
        state = state.copyWith(multi: {...state.multi}..remove(tabName));
      } else {
        state = state.copyWith(multi: {...state.multi}..add(tabName));
      }
    }
  }

  void setTabs(SelectedTabsState selectedTabs) {
    state = selectedTabs;
  }

  // Selects all tabs from the given list.
  void selectAllTabs(List<String> tabs) {
    state = state.copyWith(multi: {...state.multi}..addAll(tabs));
  }

  // Clears all selected tabs.
  void clearSelectedTab() {
    state = state.copyWith(multi: {});
  }
}
