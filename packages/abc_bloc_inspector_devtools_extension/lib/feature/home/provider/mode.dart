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

part 'mode.g.dart';

// A Riverpod provider that manages the state of the mode.
@riverpod
class Mode extends _$Mode {
  // Initializes the state with the default mode type.
  @override
  ModeType build() => ModeType.single;

  // Sets the mode to the given type.
  void setMode(ModeType type) {
    state = type;
  }
}

// Enum representing the mode types.
enum ModeType {
  single,
  multi;

  // Converts a string to a ModeType enum value.
  // Returns null if the string does not match any enum value.
  static ModeType? fromString(String? value) {
    final valueString = value?.toLowerCase();

    if (valueString == null) {
      return null;
    }

    for (final v in values) {
      if (v.name.toLowerCase() == valueString) {
        return v;
      }
    }

    return null;
  }
}
