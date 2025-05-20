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
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_sub_state.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/custom_button.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/help_button.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/json_view/json_hover_view.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/widget/popup_dialog.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/constant/flow_graph_constants.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/model/draw_object.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_is_scrolling.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_scroll_lock.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_scroll_offset.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_selected_item_index.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/provider/flow_graph_zoom_rate.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/util/flow_graph_util.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'widget/controller_widget.dart';
part 'widget/flow_graph_help_widget.dart';
part 'widget/item_widget.dart';
part 'widget/frame_widget.dart';

// A widget that displays a flow graph view with scrollable and zoomable capabilities.
class FlowGraphView extends ConsumerStatefulWidget {
  const FlowGraphView({
    super.key,
    required this.blocLogSubStates,
    required this.selectedBlocs,
    required this.viewHeight,
    required this.viewWidth,
  });

  // The selected blocs to be displayed.
  final String selectedBlocs;

  // The list of bloc log sub-states to be visualized.
  final List<BlocLogSubState>? blocLogSubStates;

  // The height of the view.
  final double viewHeight;

  // The width of the view.
  final double viewWidth;

  @override
  ConsumerState<FlowGraphView> createState() => _FlowGraphViewState();
}

class _FlowGraphViewState extends ConsumerState<FlowGraphView> {
  // Captures the contents of the flow graph and triggers a download of the image.
  //
  // This method uses a `ui.PictureRecorder` to record the drawing operations
  // on a `Canvas`. It then converts the recorded picture into an image and
  // triggers a download of the image in the browser.
  Future<void> _captureContents(
    List<BlocLogSubState>? blocLogSubStates,
  ) async {
    try {
      final (nodeDrawObjects, edgeDrawObjects, contentWidth, contentHeight) =
          getDrawObjects(
        blocSubStates: widget.blocLogSubStates,
        globalOffset: Offset.zero,
        isForCapture: true,
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      drawFrameContents(
        canvas: canvas,
        nodeDrawObjects: nodeDrawObjects,
        isForCapture: true,
      );

      drawItemContents(
        canvas: canvas,
        drawObjects: edgeDrawObjects,
        isForCapture: true,
      );

      final ui.Image picture = await recorder
          .endRecording()
          .toImage(contentWidth.toInt(), contentHeight.toInt());
      final ByteData? newByteData =
          await picture.toByteData(format: ui.ImageByteFormat.png);

      if (newByteData == null) {
        return;
      }
      // Create a blob and trigger a download in the browser
      final blob = html.Blob([newByteData]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'screenshot_${DateTime.now().toIso8601String()}.png';
      html.document.body!.children.add(anchor);

      anchor.click();

      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      extensionManager.showNotification(
        'Screenshot saved successfully',
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // Handle any errors that occur during the capture process
      // ignore: avoid_print
      print('Error capturing contents: $e');
      extensionManager.showNotification(
        'Screenshot saving failed: $e',
      );
    }
  }

  void _handleSelectedItemIndexChange({
    required int selectedItemIndex,
    required List<DrawObject>? edgeDrawObjects,
    required Offset offset,
    required double contentWidth,
    required double contentHeight,
    required double flowGraphZoomRate,
  }) {
    double objectStartX = 0;
    double objectStartY = 0;
    double objectEndX = 0;
    double objectEndY = 0;

    edgeDrawObjects?.forEach((element) {
      if (element is NodeEdgeDrawObject ||
          element is PointDrawObject ||
          element is DotLineDrawObject) {
        if (element.getIndex() == selectedItemIndex) {
          switch (element) {
            case NodeEdgeDrawObject():
              objectStartX = element.position.start.dx;
              objectStartY += element.position.start.dy;
              objectEndX = element.position.end.dx;
              objectEndY += element.position.end.dy;
              break;
            case PointDrawObject():
              objectStartX = element.offset.dx;
              objectStartY += element.offset.dy;
              objectEndX = element.offset.dx;
              objectEndY += element.offset.dy;
              break;
            case DotLineDrawObject():
              objectStartX = element.position.start.dx;
              objectStartY += element.position.start.dy;
              objectEndX = element.position.end.dx;
              objectEndY += element.position.end.dy;
              break;
            default:
          }
        }
      }
    });

    final targetOffset = getOffsetToDrawObject(
      objectStartPosition: Offset(objectStartX, objectStartY) - Offset(98, 80),
      objectEndPosition: Offset(objectEndX, objectEndY) - Offset(98, 80),
      contentWidth: contentWidth,
      contentHeight: contentHeight,
      screenHeight: widget.viewHeight -
          (FlowGraphConstants.frameVerticalPadding +
                  FlowGraphConstants.nodeMaxHeight) *
              flowGraphZoomRate,
      screenWidth: widget.viewWidth,
      currentOffset: offset,
    );

    // Update the scroll offset state.
    ref.read(flowGraphScrollOffsetProvider.notifier).setOffset(
          widget.selectedBlocs,
          targetOffset,
        );
  }

  void _handlePanUpdate({
    required DragUpdateDetails details,
    required Offset offset,
    required double contentWidth,
    required double contentHeight,
  }) {
    final deltaX = offset.dx - details.delta.dx * 3;
    final deltaY = offset.dy - details.delta.dy * 3;

    double newOffsetX = deltaX;
    double newOffsetY = deltaY;

    // Adjust the vertical offset.

    final movableVerticalDistance = contentHeight > widget.viewHeight
        ? contentHeight - widget.viewHeight
        : 0.0;

    if (deltaY >= 0) {
      if (deltaY > movableVerticalDistance) {
        if (details.delta.dy > 0) {
          newOffsetY = deltaY;
        } else {
          newOffsetY = movableVerticalDistance;
        }
      } else {
        newOffsetY = deltaY;
      }
    } else {
      newOffsetY = 0;
    }

    // Adjust the horizontal offset.
    final movableHorizontalDistance =
        contentWidth > widget.viewWidth ? contentWidth - widget.viewWidth : 0.0;

    if (deltaX >= 0) {
      if (deltaX > movableHorizontalDistance) {
        newOffsetX = movableHorizontalDistance;
      } else {
        newOffsetX = deltaX;
      }
    } else {
      newOffsetX = 0;
    }

    // Update the scroll offset state.
    ref.read(flowGraphScrollOffsetProvider.notifier).setOffset(
          widget.selectedBlocs,
          Offset(newOffsetX, newOffsetY),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the scroll lock state.
    // Watch the scroll offset state.
    final flowGraphScrollOffset = ref.watch(flowGraphScrollOffsetProvider);
    final flowGraphZoomRate = ref.watch(flowGraphZoomRateProvider);

    // Get the draw objects for nodes and edges, and calculate content dimensions.
    final (
      nodeDrawObjects,
      edgeDrawObjects,
      contentWidth,
      contentHeight,
    ) = getDrawObjects(
      blocSubStates: widget.blocLogSubStates,
      globalOffset: flowGraphScrollOffset[widget.selectedBlocs] ?? Offset.zero,
    );

    // Handle the selected item index change.
    ref.listen(flowGraphSelectedItemIndexProvider, (previous, next) {
      if (previous == next || next == -1) {
        return;
      }

      _handleSelectedItemIndexChange(
        selectedItemIndex: next,
        edgeDrawObjects: edgeDrawObjects,
        offset: flowGraphScrollOffset[widget.selectedBlocs] ?? Offset.zero,
        contentWidth: contentWidth,
        contentHeight: contentHeight,
        flowGraphZoomRate: flowGraphZoomRate,
      );
    });

    return edgeDrawObjects != null
        ? GestureDetector(
            onPanStart: (_) {
              ref
                  .read(flowGraphIsScrollingProvider.notifier)
                  .setIsScrolling(isScrolling: true);
            },
            onPanEnd: (_) {
              ref
                  .read(flowGraphIsScrollingProvider.notifier)
                  .setIsScrolling(isScrolling: false);
            },
            onPanUpdate: (details) {
              final isFlowGraphScrollLocked =
                  ref.read(flowGraphScrollLockProvider);

              if (isFlowGraphScrollLocked) {
                return;
              }

              _handlePanUpdate(
                details: details,
                offset:
                    flowGraphScrollOffset[widget.selectedBlocs] ?? Offset.zero,
                contentWidth: contentWidth,
                contentHeight: contentHeight,
              );
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF262626),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    // Widget to draw the frame.
                    FrameWidget(
                      nodeDrawObjects: nodeDrawObjects,
                      zoomRate: flowGraphZoomRate,
                    ),
                    // Widget to draw the items (edges).
                    ItemWidget(
                      drawObjects: edgeDrawObjects,
                      zoomRate: flowGraphZoomRate,
                    ),
                    // Widget to draw Zoom controller.
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ControllerWidget(
                        onCaptureTap: () async {
                          await _captureContents(
                            widget.blocLogSubStates,
                          );
                        },
                        onZoomInTap: () {
                          ref
                              .read(flowGraphZoomRateProvider.notifier)
                              .incrementZoomRate();
                        },
                        onZoomOutTap: () {
                          ref
                              .read(flowGraphZoomRateProvider.notifier)
                              .decreaseZoomRate();
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: FlowGraphHelpWidget(),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
