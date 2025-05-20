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

class PopupDialog extends StatelessWidget {
  const PopupDialog({
    super.key,
    required this.contentWidget,
    this.titleWidget,
    this.actions,
  });

  final Widget contentWidget;
  final Widget? titleWidget;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: const Color(0xFF262626),
        title: titleWidget != null
            ? Column(
                children: [
                  titleWidget!,
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                    height: 1,
                  ),
                ],
              )
            : null,
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFFD1D5DB),
        ),
        content: contentWidget,
        actions: actions ??
            [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF374151),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD1D5DB),
                  ),
                ),
              ),
            ],
      );
}
