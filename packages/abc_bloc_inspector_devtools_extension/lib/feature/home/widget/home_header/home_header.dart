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

import 'package:abc_bloc_inspector_devtools_extension/common/provider/bloc_log.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/custom_button.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/popup_dialog.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_scroll_offset.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/mode.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/search.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/selected_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Part files for different components of the HomeHeader.
part 'clear_all_button.dart';
part 'import_export_buttons.dart';
part 'mode_selector.dart';
part 'search_bar.dart';

// HomeHeader class is a widget that displays the header section of the home screen.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Row containing the search bar and mode selector.
            Row(
              children: [
                // Search bar widget.
                SearchBar(
                  onSearchWordChanged: (word) {
                    ref.read(searchProvider.notifier).setSearchWord(word);
                  },
                ),
                const VerticalDivider(
                  color: Colors.white,
                  width: 2,
                ),
                // Mode selector widget.
                ModeSelector(
                  onModeChanged: (mode) {
                    ref.read(modeProvider.notifier).setMode(mode);
                  },
                ),
              ],
            ),
            // Row containing the clear all button and import/export buttons.
            Row(
              children: [
                // Clear all button widget.
                ClearAllButton(
                  onTap: () {
                    ref.read(blocLogProvider.notifier).clearBlocLogItems();
                    ref.read(searchProvider.notifier).setSearchWord('');
                    ref
                        .read(flowGraphScrollOffsetProvider.notifier)
                        .clearAllOffset();
                    ref.read(selectedTabsProvider.notifier).clearSelectedTab();
                  },
                ),
                const SizedBox(width: 16),
                // Import and export buttons widget.
                const ImportExportButtons(),
              ],
            ),
          ],
        ),
      );
}
