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

import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/provider/active_blocs.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/help_button.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/popup_dialog.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

part 'timeline_header.dart';
part 'timeline_item.dart';
part 'timeline_help_widget.dart';

// A widget that displays a timeline view of bloc log items.
class TimelineView extends ConsumerStatefulWidget {
  const TimelineView({
    super.key,
    required this.logs,
    required this.onTapItem,
    required this.onDoubleTapItem,
    this.onTapStateChange,
    this.onScrollToEnd,
    this.isSingleBloc = true,
  });

  // List of bloc log items to display.
  final List<BlocLogItem> logs;

  // Callback function when a log item is tapped.
  final void Function(BlocLogItem) onTapItem;

  // Callback function when a log item is double-tapped.
  final void Function(BlocLogItem) onDoubleTapItem;

  // Callback function when a log item is double-tapped.
  final void Function(BlocLogItem)? onTapStateChange;

  // Callback function when the timeline view is scrolled to the end.
  final void Function(BlocLogItem)? onScrollToEnd;

  // Flag to indicate if the view is for a single bloc.
  final bool isSingleBloc;

  @override
  ConsumerState<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends ConsumerState<TimelineView> {
  // Scroll controller for the timeline view.
  final ScrollController _scrollController = ScrollController();

  // Flex values for the table columns.
  final List<int> _flexItems = const [
    3,
    3,
    2,
    3,
    2,
    2,
    1,
  ]; // Timestamp, Bloc, Type, Event, CurrentState, NextState

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchWord = ref.watch(searchProvider);
    final filteredLogs =
        widget.logs.where((log) => log.isSearchResult(searchWord)).toList();

    final isActiveBlocContains = ref
            .watch(activeBlocsProvider)
            .asData
            ?.value
            .any((bloc) => widget.logs.any((log) => log.blocName == bloc)) ??
        false;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(8),
          ),
          padding:
              const EdgeInsets.only(top: 24, right: 20, bottom: 10, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table header
              TimelineHeader(
                flexItems: _flexItems,
                isSingleBloc: widget.isSingleBloc,
                isStateChangeable: isActiveBlocContains,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (_scrollController.hasClients &&
                        _scrollController.position.maxScrollExtent > 0 &&
                        _scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        // Scroll has reached the end, reset the position to the beginning.
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );

                        // Callback to notify that the scroll has reached the end.
                        widget.onScrollToEnd?.call(
                          filteredLogs.last,
                        );
                      });
                    }
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Display each log item as a timeline item
                          ...filteredLogs.map(
                            (log) => GestureDetector(
                              onTap: () => widget.onTapItem(log),
                              onDoubleTap: () => widget.onDoubleTapItem(log),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: log == filteredLogs.first ? 8 : 0,
                                  bottom: 8,
                                ),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: TimelineItem(
                                    log: log,
                                    flexItems: _flexItems,
                                    isSingleBloc: widget.isSingleBloc,
                                    isStateChangeable: isActiveBlocContains,
                                    onTapStateChange: () =>
                                        widget.onTapStateChange?.call(log),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: TimelineHelpWidget(),
        ),
      ],
    );
  }
}
