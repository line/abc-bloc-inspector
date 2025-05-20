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

import 'package:abc_bloc_inspector/abc_bloc_inspector.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/provider/bloc_log.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/provider/extension/library_eval.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/provider/extension/service.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/util/bloc_log_util.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/util/debounce.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_view/json_view.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/flow_graph_view.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_selected_item_index.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/mode.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/provider/selected_tabs.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/widget/home_header/home_header.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/widget/tab_bar/tab_bar.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/home/widget/timeline/timeline_view.dart';
import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// HomePage is the main screen of the application that displays the log items and flow graph.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

// State class for HomePage
class _MyHomePageState extends ConsumerState<HomePage> with AutoDisposeMixin {
  double _leftFraction = 0.6;
  final debounce = Debounce(Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();

    cancelListeners();
    addAutoDisposeListener(serviceManager.connectedState, () {
      if (serviceManager.connectedState.value.connected) {
        ref.read(serviceProvider.notifier).setService(
              serviceManager.service!,
            );

        serviceManager.service?.onExtensionEvent
            .where((event) => event.extensionKind == AbcBlocConstants.blocEvent)
            .listen((event) {
          final data = event.extensionData!.data;

          final logItem = parseBlocLogItem(data);
          ref.read(blocLogProvider.notifier).addBlocLogItem(logItem);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers for bloc log items, selected tabs, and search word
    // ref.watch(blocEventListenerProvider);
    final mode = ref.watch(modeProvider);
    final blocLogItems = ref.watch(blocLogProvider);
    final selectedTabs = ref.watch(selectedTabsProvider);

    // Get all bloc names and filtered log items based on selected tabs and search word
    final allBlocNames = getAllBlocNames(blocLogItems);
    final blocLogSubStates = getFilteredBlocLogItems(
      logItems: blocLogItems,
      filterBlocs:
          (mode == ModeType.single ? selectedTabs.single : selectedTabs.multi)
              .toList(),
    );

    // Get all sorted log items from filtered log sub-states
    final allLogItemsFromFilteredLogSubStates =
        getAllSortedLogItemsFromBlocLogSubStates(blocLogSubStates);

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1F),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display the header section
          const HomeHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate initial widths based on the screen width
                  final double leftWidth = constraints.maxWidth * _leftFraction;
                  final double rightWidth =
                      constraints.maxWidth * (1 - _leftFraction);

                  return Row(
                    children: [
                      // Left panel with tab bar and flow graph view
                      Container(
                        width: leftWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTabBar(
                              labels: allBlocNames,
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: FlowGraphView(
                                selectedBlocs: selectedTabs.toString(),
                                blocLogSubStates: blocLogSubStates,
                                viewHeight: constraints.maxHeight,
                                viewWidth: leftWidth,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Drag handle to resize panels
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _leftFraction +=
                                details.delta.dx / constraints.maxWidth;

                            if (_leftFraction < 0.2) {
                              _leftFraction = 0.2;
                            }
                            if (_leftFraction > 0.8) {
                              _leftFraction = 0.8;
                            }
                          });
                        },
                        child: Center(
                          child: Image.asset(
                            'assets/images/drag_handle_horizontal.png',
                            width: 15,
                            color: const Color(0xFF404040),
                          ),
                        ),
                      ),
                      // Right panel with timeline view
                      Expanded(
                        child: SizedBox(
                          width: rightWidth,
                          child: TimelineView(
                            logs: allLogItemsFromFilteredLogSubStates,
                            isSingleBloc: mode == ModeType.single,
                            onTapItem: (BlocLogItem log) {
                              // Scroll to the selected item in the flow graph
                              // Set the selected item index on FlowGraphSelectedItemIndexProvider state
                              ref
                                  .read(
                                    flowGraphSelectedItemIndexProvider.notifier,
                                  )
                                  .setSelectedItemIndex(log.index!);

                              // Reset the selected item index after a delay for selection effect
                              Future.delayed(Duration(milliseconds: 500), () {
                                ref
                                    .read(
                                      flowGraphSelectedItemIndexProvider
                                          .notifier,
                                    )
                                    .setSelectedItemIndex(-1);
                              });
                            },
                            onDoubleTapItem: (BlocLogItem log) async {
                              // Show JSON view for the selected log item
                              await showJsonView(
                                context: context,
                                logItem: log,
                              );
                            },
                            onTapStateChange: (BlocLogItem log) async {
                              // Apply state change for the selected log item
                              // and evaluate the state using the evalInstance method

                              if (log is BlocChangeLogItem) {
                                final isAlive = Disposable();

                                final eval = await ref
                                    .watch(blocBindingEvalProvider.future);

                                final encodedNextStateData =
                                    jsonEncode(log.nextStateData);

                                await eval.evalInstance(
                                  "${AbcBlocConstants.blocBindingBlocs}['${log.blocName}']!.${AbcBlocConstants.stateReplayBlocApplyState}($encodedNextStateData)",
                                  isAlive: isAlive,
                                );
                              }
                            },
                            onScrollToEnd: (BlocLogItem log) {
                              // Scroll to the selected item in the flow graph
                              // Set the selected item index on FlowGraphSelectedItemIndexProvider state

                              debounce(() {
                                ref
                                    .read(
                                      flowGraphSelectedItemIndexProvider
                                          .notifier,
                                    )
                                    .setSelectedItemIndex(log.index!);

                                // Reset the selected item index after a delay for selection effect
                                Future.delayed(Duration(milliseconds: 500), () {
                                  ref
                                      .read(
                                        flowGraphSelectedItemIndexProvider
                                            .notifier,
                                      )
                                      .setSelectedItemIndex(-1);
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
