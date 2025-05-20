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

import 'dart:convert';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json/flutter_json.dart';

// A widget that displays a JSON item with a label.
class JsonItemView extends StatelessWidget {
  const JsonItemView({
    super.key,
    required this.label,
    required this.jsonItem,
  });

  // The label for the JSON item.
  final String label;

  // The JSON item to be displayed.
  final Map<String, dynamic> jsonItem;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row containing the icon and label.
          Row(
            children: [
              const Icon(Icons.data_object, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFD1D5DB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Container displaying the JSON item.
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF404040),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  JsonWidget(
                    json: jsonItem,
                    initialExpandDepth: 2,
                    expandIcon: const Icon(
                      Icons.expand_more,
                      color: Colors.white,
                      size: 20,
                    ),
                    collapseIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                    keyColor: Colors.white,
                    numColor: const Color(0xFF32CD32),
                    stringColor: const Color(0xFFADD8E6),
                    boolColor: const Color(0xFFFFD700),
                    arrayColor: const Color(0xFFFF7F50),
                    objectColor: const Color(0xFF9370DB),
                    noneColor: const Color(0xFFA9A9A9),
                    hiddenColor: const Color(0xFF2F4F4F),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: const Icon(
                          Icons.content_copy,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onTap: () {
                        // Make a pretty string of the JSON item.
                        final JsonEncoder encoder =
                            JsonEncoder.withIndent('  ');
                        final String prettyprint = encoder.convert(jsonItem);

                        // Copy the JSON item to clipboard.
                        extensionManager.copyToClipboard(prettyprint);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
