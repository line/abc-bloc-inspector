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

import 'dart:ui';

import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_item.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/model/bloc_log_sub_state.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/constant/flow_graph_constants.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/model/draw_object.dart';
import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/model/position.dart';

// Creates a NodeDrawObject with the given parameters.
NodeDrawObject _createNodeDrawObject({
  required String blocName,
  required String label,
  required double startX,
  required double startY,
  required double height,
}) {
  final Position nodePosition = Position(
    start: Offset(startX, startY),
    end: Offset(
      startX + FlowGraphConstants.nodeWidth,
      startY + FlowGraphConstants.nodeMaxHeight,
    ),
  );

  final Position linePosition = Position(
    start: Offset(
      (nodePosition.start.dx + nodePosition.end.dx) / 2,
      nodePosition.end.dy + FlowGraphConstants.nodeAndLineVerticalGap,
    ),
    end: Offset(
      (nodePosition.start.dx + nodePosition.end.dx) / 2,
      height * 2, // To cover in case of zoom out
    ),
  );

  return DrawObject.node(
    blocName: blocName,
    label: label,
    nodePosition: nodePosition,
    nodeLinePosition: linePosition,
  ) as NodeDrawObject;
}

// Generates the draw objects for the flow graph based on the given parameters.
// | frameHorizontalPadding | node1-1 | nodeHorizontalGap | node1-2 ... | nodeGroupAndNodeGroupHorizontalGap | node2-1 | nodeHorizontalGap | node2-2... | frameHorizontalPadding |
(
  Map<String, List<NodeDrawObject>> nodeDrawObjects,
  List<DrawObject>? edgeDrawObjects,
  double contentWidth,
  double contentHeight,
) getDrawObjects({
  required List<BlocLogSubState>? blocSubStates,
  required Offset globalOffset,
  bool isForCapture = false,
}) {
  if (blocSubStates?.isEmpty ?? true) {
    return ({}, null, 0, 0);
  }

  double globalNodeStartX =
      FlowGraphConstants.frameHorizontalPadding - globalOffset.dx;

  final (contentWidth, contentHeight) = getDrawableContentSize(
    blocSubStates: blocSubStates,
  );

  final Map<String, List<NodeDrawObject>> nodeDrawObjectsMerged = {};
  final List<DrawObject> edgeDrawObjectsMerged = [];

  for (final blocSubState in blocSubStates!) {
    final List<String> blocNodes = blocSubState.blocNodes;

    final Map<String, NodeDrawObject> nodeDrawObjects = {};
    double nodeStartX = globalNodeStartX;

    for (var blocLoop = 0; blocLoop < blocNodes.length; blocLoop++) {
      final object = _createNodeDrawObject(
        blocName: blocSubState.blocName,
        label: blocNodes[blocLoop],
        startX: nodeStartX,
        startY: FlowGraphConstants.frameVerticalPadding,
        height: contentHeight,
      );

      nodeDrawObjects[blocNodes[blocLoop]] = object;
      nodeStartX = nodeStartX +
          FlowGraphConstants.nodeWidth +
          FlowGraphConstants.nodeHorizontalGap;
    }

    // In case of state change not captured event
    if (blocNodes.isEmpty) {
      final object = _createNodeDrawObject(
        blocName: blocSubState.blocName,
        label: '',
        startX: nodeStartX,
        startY: FlowGraphConstants.frameVerticalPadding,
        height: contentHeight,
      );

      nodeDrawObjects[''] = object;
      nodeStartX = nodeStartX +
          FlowGraphConstants.nodeWidth +
          FlowGraphConstants.nodeHorizontalGap;
    }

    // For item objects
    final List<DrawObject> edgeDrawObjects = [];
    final double edgeStartX = globalNodeStartX;
    double edgeStartY = 0;

    for (final item in blocSubState.logItems) {
      final index = blocSubState.logItems.indexOf(item);
      edgeStartY = (isForCapture
              ? FlowGraphConstants.frameVerticalPadding +
                  FlowGraphConstants.nodeMaxHeight
              : 0) +
          ((blocSubStates.length > 1 ? item.index! : index + 1) *
              FlowGraphConstants.eventVerticalGap) -
          globalOffset.dy;

      switch (item) {
        case BlocChangeLogItem():
          final currentNodeDrawObject =
              nodeDrawObjects[item.currentState] as NodeDrawObject;
          final nextNodeDrawObject =
              nodeDrawObjects[item.nextState] as NodeDrawObject;

          final DrawObject edgeObject = DrawObject.nodeEdge(
            index: item.index!,
            position: Position(
              start: Offset(
                currentNodeDrawObject.nodeLinePosition.start.dx,
                edgeStartY,
              ),
              end: Offset(
                nextNodeDrawObject.nodeLinePosition.start.dx,
                edgeStartY,
              ),
            ),
            data: {
              'currentStateData': item.currentStateData,
              'nextStateData': item.nextStateData,
            },
          );

          edgeDrawObjects.add(edgeObject);
          break;
        case BlocEventLogItem():
          edgeDrawObjects.add(
            DrawObject.dotLine(
              index: item.index!,
              label: item.eventName,
              position: Position(
                start: Offset(
                  edgeStartX -
                      FlowGraphConstants.nodeGroupAndNodeGroupHorizontalGap / 2,
                  edgeStartY,
                ),
                end: Offset(
                  nodeStartX + FlowGraphConstants.nodeHorizontalGap,
                  edgeStartY,
                ),
              ),
              data: item.eventData,
            ),
          );

          break;
        case BlocCreateLogItem():
          edgeDrawObjects.add(
            DrawObject.point(
              index: item.index!,
              label: 'CREATE',
              offset: Offset(
                edgeStartX - FlowGraphConstants.nodeHorizontalGap,
                edgeStartY,
              ),
            ),
          );
          break;
        case BlocErrorLogItem():
          edgeDrawObjects.add(
            DrawObject.point(
              index: item.index!,
              label: 'ERROR',
              offset: Offset(
                edgeStartX - FlowGraphConstants.nodeHorizontalGap,
                edgeStartY,
              ),
              data: item.error,
            ),
          );
          break;
        case BlocCloseLogItem():
          edgeDrawObjects.add(
            DrawObject.point(
              index: item.index!,
              label: 'CLOSE',
              offset: Offset(
                edgeStartX - FlowGraphConstants.nodeHorizontalGap,
                edgeStartY,
              ),
            ),
          );
          break;
      }
    }

    nodeDrawObjectsMerged[blocSubState.blocName] =
        nodeDrawObjects.values.toList();
    edgeDrawObjectsMerged.addAll(edgeDrawObjects);

    globalNodeStartX =
        nodeStartX + FlowGraphConstants.nodeGroupAndNodeGroupHorizontalGap;
  }

  return (
    nodeDrawObjectsMerged,
    edgeDrawObjectsMerged,
    contentWidth,
    contentHeight
  );
}

// Draws a dashed line on the canvas.
void drawDashedLine({
  required Canvas canvas,
  required Offset start,
  required Offset end,
  required double dashWidth,
  required double dashSpace,
  required Paint paint,
}) {
  final double totalDistance = (end - start).distance;
  final double dashCount =
      (totalDistance / (dashWidth + dashSpace)).floorToDouble();

  final Offset direction = (end - start) / totalDistance;

  for (int i = 0; i < dashCount; i++) {
    final double startDistance = i * (dashWidth + dashSpace);
    final double endDistance = startDistance + dashWidth;

    final Offset dashStart = start + direction * startDistance;
    final Offset dashEnd = start + direction * endDistance;

    canvas.drawLine(dashStart, dashEnd, paint);
  }
}

(double width, double height) getDrawableContentSize({
  required List<BlocLogSubState>? blocSubStates,
}) {
  double height = 0;
  double width = 0;

  if (blocSubStates != null && blocSubStates.isNotEmpty) {
    int logsNum = 0;
    int nodeNum = 0;
    for (final blocSubState in blocSubStates) {
      logsNum += blocSubState.logItems.length;
      nodeNum +=
          blocSubState.blocNodes.isEmpty ? 1 : blocSubState.blocNodes.length;
    }
    height = FlowGraphConstants.frameVerticalPadding +
        FlowGraphConstants.nodeMaxHeight +
        FlowGraphConstants.nodeAndLineVerticalGap +
        (logsNum + 2) * FlowGraphConstants.eventVerticalGap;

    width = FlowGraphConstants.frameHorizontalPadding * 2 +
        FlowGraphConstants.nodeWidth * nodeNum +
        FlowGraphConstants.nodeHorizontalGap * (nodeNum - 1) +
        FlowGraphConstants.nodeGroupAndNodeGroupHorizontalGap *
            (blocSubStates.length - 1);
  }

  return (width, height);
}

Offset getOffsetToDrawObject({
  required Offset objectStartPosition,
  required Offset objectEndPosition,
  required double contentHeight,
  required double contentWidth,
  required double screenHeight,
  required double screenWidth,
  required Offset currentOffset,
}) {
  final double heightMax = screenHeight - 100;
  final double widthMax = screenWidth - 100;

  double targetX = 0;
  double targetY = 0;

  final translatedObjectStartPosition = objectStartPosition + currentOffset;
  final translatedObjectEndPosition = objectEndPosition + currentOffset;

  if (objectStartPosition.dx < 0 ||
      (objectStartPosition.dx + FlowGraphConstants.nodeWidth) > widthMax) {
    if (translatedObjectStartPosition.dx < 0) {
      targetX = 0;
    } else if (translatedObjectEndPosition.dx > widthMax) {
      // Check whether draw object's right side is out of screen
      if (translatedObjectEndPosition.dx - widthMax >
          contentWidth - screenWidth) {
        targetX = currentOffset.dx + contentWidth - screenWidth;
      } else {
        targetX = translatedObjectEndPosition.dx - widthMax + 100;
      }
    } else {
      targetX = translatedObjectStartPosition.dx;
    }
  } else {
    targetX = currentOffset.dx;
  }

  if (objectStartPosition.dy < 0 ||
      (objectStartPosition.dy + FlowGraphConstants.nodeMaxHeight) > heightMax) {
    if (translatedObjectStartPosition.dy < 0) {
      targetY = 0;
    } else if (translatedObjectEndPosition.dy > heightMax) {
      // Check whether draw object's bottom side is out of screen
      if (translatedObjectEndPosition.dy - heightMax >
          contentHeight - screenHeight) {
        targetY = currentOffset.dy + contentHeight - screenHeight;
      } else {
        targetY = translatedObjectEndPosition.dy - heightMax + 100;
      }
    } else {
      targetY = translatedObjectStartPosition.dy;
    }
  } else {
    targetY = currentOffset.dy;
  }

  return Offset(
    targetX,
    targetY,
  );
}
