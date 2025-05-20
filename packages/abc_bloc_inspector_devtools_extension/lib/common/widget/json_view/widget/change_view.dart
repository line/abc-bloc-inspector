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

import 'package:abc_bloc_inspector_devtools_extension/common/util/common_util.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_item_view.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_view/widget/diff_select_radio_buttons.dart';
import 'package:flutter/material.dart';

/// ChangeView widget displays the differences between two JSON data states.
class ChangeView extends StatefulWidget {
  const ChangeView({
    super.key,
    required this.dataA,
    required this.dataB,
  });

  /// The current state of the JSON data.
  final Map<String, dynamic> dataA;

  /// The next state of the JSON data.
  final Map<String, dynamic> dataB;

  @override
  State<ChangeView> createState() => _ChangeViewState();
}

class _ChangeViewState extends State<ChangeView> {
  int diffViewType = 0;

  /// Builds the UI for displaying the JSON data differences.
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: diffViewType == 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Displays the current state of the JSON data.
                        Expanded(
                          child: JsonItemView(
                            label: 'Current State',
                            jsonItem: widget.dataA,
                          ),
                        ),
                        const SizedBox(width: 24),

                        /// Displays the next state of the JSON data.
                        Expanded(
                          child: JsonItemView(
                            label: 'Next State',
                            jsonItem: widget.dataB,
                          ),
                        ),
                      ],
                    )
                  :

                  /// Displays the differences between the current and next state.
                  JsonItemView(
                      label: 'Current State / Next State Difference',
                      jsonItem: getDifferences(widget.dataA, widget.dataB),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          /// Radio buttons for selecting the diff view type.
          DiffSelectRadioButtons(
            nowValue: diffViewType,
            onSelect: (type) {
              setState(() {
                diffViewType = type;
              });
            },
          ),
        ],
      );
}
