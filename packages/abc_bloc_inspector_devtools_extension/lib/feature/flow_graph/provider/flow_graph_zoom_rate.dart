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

part 'flow_graph_zoom_rate.g.dart';

// Riverpod provider class for managing the zoom rate of a flow graph
@riverpod
class FlowGraphZoomRate extends _$FlowGraphZoomRate {
  @override
  double build() => 0.8;

  // Method to increment the zoom rate by 0.1, with a maximum limit of 1.5
  void incrementZoomRate() {
    double newValue = state + 0.1;
    if (newValue > 1.0) {
      newValue = 1.0;
    }
    state = newValue;
  }

  // Method to decrease the zoom rate by 0.1, with a minimum limit of 0.5
  void decreaseZoomRate() {
    double newValue = state - 0.1;
    if (newValue < 0.5) {
      newValue = 0.5;
    }
    state = newValue;
  }
}
