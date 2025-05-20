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

import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_item_view.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_view/widget/change_view.dart';
import 'package:flutter/material.dart';

/// The JsonHoverView widget is used to visually display JSON data.
/// It provides different layouts depending on the length of the data.
class JsonHoverView extends StatefulWidget {
  const JsonHoverView({
    super.key,
    required this.data,
  });

  /// A list of JSON data to be displayed.
  final List<Map<String, dynamic>> data;

  @override
  State<JsonHoverView> createState() => _JsonHoverViewState();
}

class _JsonHoverViewState extends State<JsonHoverView> {
  /// Represents the currently selected diff view type.
  int diffViewType = 0;

  @override
  Widget build(BuildContext context) => Container(
        width: widget.data.length == 1 ? 500 : 800,
        height: 500,
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF404040),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: buildChildWidget(),
      );

  Widget buildChildWidget() {
    if (widget.data.length == 1) {
      return JsonItemView(label: 'Event data', jsonItem: widget.data[0]);
    } else if (widget.data.length == 2) {
      return ChangeView(
        dataA: widget.data[0],
        dataB: widget.data[1],
      );
    }
    return const SizedBox();
  }
}
