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

import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_item_view.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_view/widget/change_view.dart';
import 'package:flutter/material.dart';

Future<void> showJsonView({
  required BuildContext context,
  required BlocLogItem logItem,
}) async {
  if (logItem is BlocCreateLogItem || logItem is BlocCloseLogItem) {
    return;
  }

  Widget buildViewChild(StateSetter setState) {
    if (logItem is BlocEventLogItem) {
      return JsonItemView(label: 'Event', jsonItem: logItem.eventData);
    } else if (logItem is BlocChangeLogItem) {
      return ChangeView(
        dataA: logItem.currentStateData,
        dataB: logItem.nextStateData,
      );
    } else if (logItem is BlocErrorLogItem) {
      return JsonItemView(label: 'message', jsonItem: logItem.error);
    }
    return const SizedBox();
  }

  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xFF171717).withValues(alpha: 0.3),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final viewChild = buildViewChild(setState);
        final title = getTitle(logItem);

        return AlertDialog(
          backgroundColor: const Color(0xFF262626),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          title: _DialogTitle(title: title),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: viewChild,
          ),
        );
      },
    ),
  );
}

String getTitle(BlocLogItem logItem) {
  if (logItem is BlocEventLogItem) {
    return '${logItem.blocName} >> EVENT';
  } else if (logItem is BlocChangeLogItem) {
    return '${logItem.blocName} >> CHANGE >> ${logItem.currentState} -> ${logItem.nextState}';
  } else if (logItem is BlocErrorLogItem) {
    return '${logItem.blocName} >> ERROR';
  }
  return '';
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF374151),
              ),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      );
}
