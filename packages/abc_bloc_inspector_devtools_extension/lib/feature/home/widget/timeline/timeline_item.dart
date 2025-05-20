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

part of 'timeline_view.dart';

// A widget that represents a single item in the timeline view.
class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.log,
    required this.flexItems,
    required this.isSingleBloc,
    required this.isStateChangeable,
    this.onTapStateChange,
  });

  // The log item to display.
  final BlocLogItem log;

  // Flex values for the table columns.
  final List<int> flexItems;

  // Flag to indicate if the view is for a single bloc.
  final bool isSingleBloc;

  // Flag to indicate if the log item is state changeable.
  final bool isStateChangeable;

  // Callback function when the state change icon is tapped.
  final void Function()? onTapStateChange;

  // Text style for the log item text.
  static TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  // Returns a widget displaying the event name if the log is a BlocEventLogItem.
  Widget getEventName() => Text(
        log is BlocEventLogItem ? (log as BlocEventLogItem).eventName : '-',
        textAlign: TextAlign.left,
        style: textStyle,
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF404040),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Display the timestamp of the log item.
            Expanded(
              flex: flexItems[0],
              child: Text(
                DateFormat('HH:mm:ss.SSS').format(log.timestamp),
                style: textStyle,
              ),
            ),
            if (!isSingleBloc) ...[
              const SizedBox(width: 8),
              // Display the bloc name if not a single bloc view.
              Expanded(
                flex: flexItems[1],
                child: Text(
                  log.blocName,
                  style: textStyle,
                ),
              ),
            ],
            const SizedBox(width: 8),
            // Display the type of the log item.
            Expanded(
              flex: flexItems[2],
              child: Text(
                log.getTypeString(),
                style: textStyle,
              ),
            ),
            const SizedBox(width: 8),
            // Display the event name of the log item.
            Expanded(
              flex: flexItems[3],
              child: getEventName(),
            ),
            const SizedBox(width: 8),
            // Display the current state of the log item if it is a BlocChangeLogItem.
            Expanded(
              flex: flexItems[4],
              child: Text(
                log is BlocChangeLogItem
                    ? (log as BlocChangeLogItem).currentState
                    : '-',
                style: textStyle,
              ),
            ),
            const SizedBox(width: 8),
            // Display the next state of the log item if it is a BlocChangeLogItem.
            Expanded(
              flex: flexItems[5],
              child: Text(
                log is BlocChangeLogItem
                    ? (log as BlocChangeLogItem).nextState
                    : '-',
                style: textStyle,
              ),
            ),
            if (isStateChangeable) ...[
              const SizedBox(width: 4),
              // Display the bloc name if not a single bloc view.
              Expanded(
                flex: flexItems[6],
                child: log is BlocChangeLogItem
                    ? GestureDetector(
                        onTap: onTapStateChange,
                        behavior: HitTestBehavior.opaque,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: const Icon(
                              Icons.sync_alt,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ],
        ),
      );
}
