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

import 'package:abc_bloc_inspector_devtools_extension/common/widget/custom_button.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/mode.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/selected_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'tab_bar_item.dart';

// A custom tab bar widget that displays a list of tabs and allows selection.
class CustomTabBar extends ConsumerWidget {
  const CustomTabBar({
    super.key,
    required this.labels,
  });

  // List of labels for the tabs.
  final List<String> labels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current mode and selected tabs from the providers.
    final mode = ref.watch(modeProvider);
    final selectedTabs = ref.watch(selectedTabsProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 60,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF262626),
        ),
        child: Row(
          children: [
            // Scrollable row of tab items.
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: labels.map((label) {
                    final isLastLabel = labels.last == label;
                    return Padding(
                      padding: EdgeInsets.only(right: isLastLabel ? 0 : 4),
                      child: TabBarItem(
                        label: label,
                        isSelected:
                            (mode == ModeType.single ? selectedTabs.single : selectedTabs.multi).contains(label),
                        onTap: () {
                          ref.read(selectedTabsProvider.notifier).toggleSelectedTab(label);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Additional buttons for multi-mode.
            if (mode == ModeType.multi) ...[
              const SizedBox(width: 16),
              Row(
                children: [
                  CustomButton(
                    iconWidget: Image.asset(
                      'assets/images/done_all.png',
                      width: 16,
                      color: Colors.white,
                    ),
                    label: 'All',
                    onTap: () {
                      ref.read(selectedTabsProvider.notifier).selectAllTabs(labels);
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    iconWidget: Image.asset(
                      'assets/images/close.png',
                      width: 16,
                      color: Colors.white,
                    ),
                    label: 'Clear',
                    onTap: () {
                      ref.read(selectedTabsProvider.notifier).clearSelectedTab();
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
