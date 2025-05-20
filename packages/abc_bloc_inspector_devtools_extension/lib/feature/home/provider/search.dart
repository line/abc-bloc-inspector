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

part 'search.g.dart';

// A Riverpod provider that manages the state of the search word.
@riverpod
class Search extends _$Search {
  // Initializes the state with an empty search word.
  @override
  String build() => '';

  // Sets the search word to the given value.
  void setSearchWord(String word) {
    state = word;
  }
}
