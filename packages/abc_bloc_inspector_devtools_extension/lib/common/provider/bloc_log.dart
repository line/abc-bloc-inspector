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

import 'package:abc_bloc_inspector_devtools_extension/common/constant/common_constants.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/util/bloc_log_util.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/model/selected_tabs_state.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/mode.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/selected_tabs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bloc_log.g.dart';

// Provider class for managing Bloc log items.
@riverpod
class BlocLog extends _$BlocLog {
  // Initializes the BlocLog with an empty list of BlocLogItem.
  @override
  List<BlocLogItem> build() => [];

  // Adds a new BlocLogItem to the state.
  void addBlocLogItem(BlocLogItem logItem) {
    state = [...state, logItem];
  }

  // Clears all BlocLogItems from the state.
  void clearBlocLogItems() {
    state = [];
  }

  // Exports the current BlocLogItems to a JSON file.
  Future<bool> exportBlocLogItems() async {
    try {
      // Get package information
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // Read the current mode and selected tabs from providers
      final mode = ref.read(modeProvider);
      final selectedTabs = ref.read(selectedTabsProvider);

      // Export the log data to a JSON file
      await exportBlocLog({
        CommonConstants.versionKey: packageInfo.version,
        CommonConstants.modeKey: mode.name,
        CommonConstants.selectedTabsKey: selectedTabs.toJson(),
        CommonConstants.dataKey: state,
      });

      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // Print error message if export fails
      // ignore: avoid_print
      print('export error: $e');
      return false;
    }
  }

  // Imports BlocLogItems from a JSON file and updates the state.
  Future<bool> importBlocLogItems() async {
    try {
      // Import the log data from a JSON file
      final importData = await importBlocLog();
      // TODO : Version comparing for checking compatibility
      final version = importData.remove(CommonConstants.versionKey);
      // Print the version of the imported file
      // ignore: avoid_print
      print('import file version: $version');

      // Update the state with the imported log items
      state = List<BlocLogItem>.from(
        importData[CommonConstants.dataKey].map((e) => BlocLogItem.fromJson(e)),
      );
      // Update the mode and selected tabs with the imported data
      ref.read(modeProvider.notifier).setMode(
            ModeType.fromString(importData[CommonConstants.modeKey]) ?? ModeType.single,
          );
      ref.read(selectedTabsProvider.notifier).setTabs(
            SelectedTabsState.fromJson(
              importData[CommonConstants.selectedTabsKey],
            ),
          );

      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // Print error message if import fails
      // ignore: avoid_print
      print('import error: $e');
      return false;
    }
  }
}
