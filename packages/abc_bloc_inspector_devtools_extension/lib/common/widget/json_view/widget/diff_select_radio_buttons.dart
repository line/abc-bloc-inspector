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

import 'package:flutter/material.dart';

// A widget that provides radio buttons to select the diff view type.
class DiffSelectRadioButtons extends StatelessWidget {
  const DiffSelectRadioButtons({
    super.key,
    required this.nowValue,
    required this.onSelect,
  });

  // The current selected value of the radio buttons.
  final int nowValue;

  // Callback function to be called when a radio button is selected.
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          // Radio button for 'All' view type.
          Radio<int>(
            value: 0,
            fillColor: WidgetStateColor.resolveWith((states) => Colors.green),
            focusColor: WidgetStateColor.resolveWith((states) => Colors.green),
            groupValue: nowValue,
            onChanged: (value) => onSelect(value!),
          ),
          GestureDetector(
            onTap: () => onSelect(0),
            child: const Text(
              'All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          // Radio button for 'Diff' view type.
          Radio<int>(
            value: 1,
            fillColor: WidgetStateColor.resolveWith((states) => Colors.green),
            focusColor: WidgetStateColor.resolveWith((states) => Colors.green),
            groupValue: nowValue,
            onChanged: (value) => onSelect(value!),
          ),
          GestureDetector(
            onTap: () => onSelect(1),
            child: const Text(
              'Diff',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
}
