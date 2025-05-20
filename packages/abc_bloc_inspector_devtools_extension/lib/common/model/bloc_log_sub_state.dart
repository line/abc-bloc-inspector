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

import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bloc_log_sub_state.freezed.dart';
part 'bloc_log_sub_state.g.dart';

// Represents a sub-state of Bloc logs, containing nodes and log items.
@Freezed(genericArgumentFactories: true, toJson: true, fromJson: true)
sealed class BlocLogSubState with _$BlocLogSubState {
  // Factory constructor for creating a BlocLogSubState.
  factory BlocLogSubState({
    // A Bloc Name
    required String blocName,

    // A list of Bloc node identifiers.
    @Default([]) List<String> blocNodes,

    // A list of Bloc log items.
    @Default([]) List<BlocLogItem> logItems,
  }) = _BlocLogSubState;

  // Factory constructor for creating a BlocLogSubState from JSON.
  factory BlocLogSubState.fromJson(Map<String, dynamic> json) => _$BlocLogSubStateFromJson(json);
}
