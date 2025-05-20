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

part of '../flow_graph_view.dart';

// A widget that displays the frame of the flow graph.
class FrameWidget extends StatelessWidget {
  const FrameWidget({
    super.key,
    required this.nodeDrawObjects,
    required this.zoomRate,
  });

  // The list of node draw objects to be visualized.
  final Map<String, List<NodeDrawObject>> nodeDrawObjects;

  // The zoom rate of the flow graph.
  final double zoomRate;

  @override
  Widget build(BuildContext context) => CustomPaint(
        foregroundPainter: FramePainter(
          nodeDrawObjects: nodeDrawObjects,
          zoomRate: zoomRate,
        ),
      );
}

// A custom painter to draw the frame of the flow graph.
class FramePainter extends CustomPainter {
  FramePainter({
    required this.nodeDrawObjects,
    required this.zoomRate,
  });

  // The list of node draw objects to be visualized.
  final Map<String, List<NodeDrawObject>> nodeDrawObjects;

  // The zoom rate of the flow graph.
  final double zoomRate;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(zoomRate, zoomRate);

    drawFrameContents(
      canvas: canvas,
      nodeDrawObjects: nodeDrawObjects,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Draws text on the canvas at the specified position.
Rect drawText({
  required Canvas canvas,
  required double x,
  required double y,
  required String text,
  required TextStyle style,
  bool isCentered = true,
  double? maxWidth,
}) {
  final textSpan = TextSpan(
    text: text,
    style: style,
  );

  final textPainter = TextPainter()
    ..text = textSpan
    ..textDirection = TextDirection.ltr
    ..textAlign = TextAlign.center
    ..layout();

  if (maxWidth != null) {
    // Measure the text
    textPainter.layout(maxWidth: maxWidth);
  }

  final xCenter = x - textPainter.width / 2;
  final yCenter = y - textPainter.height / 2;
  Offset offset = Offset(xCenter, yCenter);

  if (isCentered) {
    offset = Offset(xCenter, yCenter);
  } else {
    offset = Offset(x, yCenter);
  }

  textPainter.paint(canvas, offset);

  return Rect.fromLTWH(
    offset.dx,
    offset.dy,
    textPainter.width,
    textPainter.height,
  );
}

void drawFrameContents({
  required Canvas canvas,
  required Map<String, List<NodeDrawObject>> nodeDrawObjects,
  bool isForCapture = false,
}) {
  final paint = Paint()
    ..color = const Color(0xFF525252)
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  final linePaint = Paint()
    ..color = const Color(0xFF525252)
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  final BorderRadius borderRadius = BorderRadius.circular(12);

  for (final key in nodeDrawObjects.keys) {
    final nodeObjects = nodeDrawObjects[key] ?? [];

    for (final nodeObject in nodeObjects) {
      // Draw the node rectangle with rounded corners
      final Rect rect = Rect.fromPoints(
        nodeObject.nodePosition.start,
        nodeObject.nodePosition.end,
      );
      canvas.drawRRect(
        borderRadius.toRRect(rect),
        paint,
      );

      // Draw the line inside the node
      canvas.drawLine(
        nodeObject.nodeLinePosition.start,
        nodeObject.nodeLinePosition.end,
        linePaint,
      );

      // Draw the node label text
      drawText(
        canvas: canvas,
        x: nodeObject.nodeLinePosition.start.dx,
        y: nodeObject.nodePosition.start.dy +
            (FlowGraphConstants.nodeMaxHeight / 2),
        text: nodeObject.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        maxWidth: nodeObject.nodePosition.end.dx -
            nodeObject.nodePosition.start.dx -
            10,
      );

      final nodeObjectIndex = nodeObjects.indexOf(nodeObject);
      if (nodeObjectIndex == 0) {
        // Draw the first nodeObject's bloc name
        drawText(
          canvas: canvas,
          x: nodeObject.nodePosition.start.dx - 70,
          y: nodeObject.nodePosition.start.dy - 0,
          text: nodeObject.blocName,
          style: TextStyle(
            color: isForCapture ? Colors.black : Colors.white,
            fontSize: 10,
          ),
        );
      }
    }

    // Draw the line inside the node
    final lastKey = nodeDrawObjects.keys.last;
    if (key != lastKey) {
      final lastNodeObject = nodeObjects.last;
      final separateLinePositionStart = lastNodeObject.nodePosition.end +
          const Offset(
            (FlowGraphConstants.nodeHorizontalGap +
                    FlowGraphConstants.nodeGroupAndNodeGroupHorizontalGap) /
                2,
            -FlowGraphConstants.nodeMaxHeight / 2,
          );
      final separateLinePositionEnd = Offset(
        lastNodeObject.nodePosition.end.dx +
            (FlowGraphConstants.nodeHorizontalGap +
                    FlowGraphConstants.nodeGroupAndNodeGroupHorizontalGap) /
                2,
        lastNodeObject.nodeLinePosition.end.dy,
      );

      drawDashedLine(
        canvas: canvas,
        start: separateLinePositionStart,
        end: separateLinePositionEnd,
        dashWidth: 6,
        dashSpace: 12,
        paint: paint,
      );
    }
  }
}
