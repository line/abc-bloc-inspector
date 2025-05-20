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

part 'selected_tabs_state.freezed.dart';
part 'selected_tabs_state.g.dart';

// A state class that holds the selected tabs for single and multi modes.
@freezed
sealed class SelectedTabsState with _$SelectedTabsState {
  // Factory constructor for creating a new `SelectedTabsState` instance.
  //
  // The `single` and `multi` sets are initialized to empty sets by default.
  factory SelectedTabsState({
    @Default({}) Set<String> single, // Set of selected tabs in single mode.
    @Default({}) Set<String> multi, // Set of selected tabs in multi mode.
  }) = _SelectedTabsState;
  SelectedTabsState._();

  // Factory constructor for creating a new `SelectedTabsState` instance from a JSON map.
  factory SelectedTabsState.fromJson(Map<String, dynamic> json) =>
      _$SelectedTabsStateFromJson(json);
}
