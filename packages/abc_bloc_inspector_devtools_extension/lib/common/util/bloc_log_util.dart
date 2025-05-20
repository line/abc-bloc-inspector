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

import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_sub_state.dart';

// Parses a log map into a BlocLogItem object.
BlocLogItem parseBlocLogItem(Map<String, dynamic> log) {
  final timeStamp = DateTime.parse(log['timestamp']);
  final type = NodeType.fromString(log['type']);
  if (type == null) {
    throw Exception('Invalid type: ${log['type']}');
  }
  final blocName = log['blocName'];

  // Switch case to handle different NodeType values.
  switch (type) {
    case NodeType.create:
      return BlocLogItem.create(
        timestamp: timeStamp,
        blocName: blocName,
      );
    case NodeType.event:
      return BlocLogItem.event(
        timestamp: timeStamp,
        blocName: blocName,
        eventName: log['eventName'],
        eventData: Map<String, dynamic>.from(log['eventData']!),
      );
    case NodeType.change:
      return BlocLogItem.change(
        timestamp: timeStamp,
        blocName: blocName,
        currentState: log['currentState'],
        nextState: log['nextState'],
        currentStateData: Map<String, dynamic>.from(log['currentStateData']!),
        nextStateData: Map<String, dynamic>.from(log['nextStateData']!),
      );
    case NodeType.error:
      return BlocLogItem.error(
        timestamp: timeStamp,
        blocName: blocName,
        error: Map<String, dynamic>.from(log['error']!),
      );
    case NodeType.close:
      return BlocLogItem.close(
        timestamp: timeStamp,
        blocName: blocName,
      );
  }
}

// Retrieves all unique bloc names from a list of BlocLogItem objects.
List<String> getAllBlocNames(List<BlocLogItem> logItems) => logItems.map((e) => e.blocName).toSet().toList();

// Filters BlocLogItems based on provided bloc names and search word.
List<BlocLogSubState> getFilteredBlocLogItems({
  required List<BlocLogItem> logItems,
  required List<String> filterBlocs,
}) {
  final Map<String, BlocLogSubState> data = {};
  int index = 1;

  // Iterate through each log item.
  for (final BlocLogItem item in logItems) {
    final blocName = item.blocName;
    if (filterBlocs.contains(blocName)) {
      final BlocLogSubState blocLogSubState = data[blocName] ?? BlocLogSubState(blocName: blocName);
      final List<String> blocNodes = [...blocLogSubState.blocNodes];

      // Handle BlocChangeLogItem specifically.
      if (item is BlocChangeLogItem) {
        if (!blocNodes.contains(item.currentState)) {
          blocNodes.add(item.currentState);
        }
        if (!blocNodes.contains(item.nextState)) {
          blocNodes.add(item.nextState);
        }
      }

      // Update data map with new log item.
      data.addAll({
        item.blocName: blocLogSubState.copyWith(
          blocNodes: blocNodes,
          logItems: [
            ...blocLogSubState.logItems,
            item.copyWith(
              index: index++,
            ),
          ],
        ),
      });
    }
  }

  return data.values.toList();
}

// Retrieves all log items from a list of BlocLogSubState objects and sorts them by index.
List<BlocLogItem> getAllSortedLogItemsFromBlocLogSubStates(
  List<BlocLogSubState> blocLogSubStates,
) {
  final List<BlocLogItem> allLogItems = [];
  for (final blocLogSubState in blocLogSubStates) {
    allLogItems.addAll(blocLogSubState.logItems);
  }

  // Sort log items by index.
  allLogItems.sort((a, b) => (a.index ?? 0).compareTo(b.index ?? 0));

  return allLogItems;
}

Future<void> exportBlocLog(Map<String, dynamic> data) async {
  final json = jsonEncode(data);
  final bytes = utf8.encode(json);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = '${DateTime.now().toIso8601String()}.json';
  html.document.body!.children.add(anchor);

  anchor.click();

  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

// Imports Bloc log data from a JSON file.
Future<Map<String, dynamic>> importBlocLog() async {
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '.json';

  uploadInput.click();

  final completer = Completer<Map<String, dynamic>>();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files!.isEmpty) {
      return;
    }
    final reader = html.FileReader();

    reader.onLoadEnd.listen((e) {
      final content = reader.result as String;
      final data = jsonDecode(content) as Map<String, dynamic>;
      completer.complete(data);
    });

    reader.readAsText(files[0]);
  });

  return completer.future;
}
