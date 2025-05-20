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

// A custom button widget with an icon, label, and onTap callback.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.iconWidget,
    this.label,
    required this.onTap,
  });

  // The icon widget to be displayed inside the button.
  final Widget? iconWidget;

  // The label text to be displayed inside the button.
  final String? label;

  // The callback function to be executed when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        // The onTap callback function.
        onTap: onTap,
        // The border radius of the button.
        borderRadius: BorderRadius.circular(8),
        child: Container(
          // Padding inside the button.
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          // Decoration of the button.
          decoration: BoxDecoration(
            color: const Color(0xFF404040),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The icon widget.
              if (iconWidget != null) ...[
                iconWidget!,
              ],
              // Add spacing between icon and label if both are present.
              if (iconWidget != null && label != null) const SizedBox(width: 8),
              // The label text.
              if (label != null) ...[
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}
