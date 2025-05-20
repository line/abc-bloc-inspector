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

// A widget that displays items (edges) in the flow graph.
class ItemWidget extends ConsumerStatefulWidget {
  const ItemWidget({
    super.key,
    required this.drawObjects,
    required this.zoomRate,
  });

  // The list of draw objects to be visualized.
  final List<DrawObject>? drawObjects;

  // The zoom rate of the flow graph.
  final double zoomRate;

  @override
  ConsumerState<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends ConsumerState<ItemWidget> {
  List<Map<String, dynamic>>? hoveredData; // Data to be displayed on hover
  bool isHoverViewVisible = false; // Flag to check if hover view is visible
  Offset hoverViewPosition = Offset.zero; // Position of the hover view
  Offset? hoverPosition; // Current hover position

  // The controller for the overlay portal that displays the hover json view.
  final OverlayPortalController _jsonHoverViewController =
      OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    final flowGraphSelectedItemIndex =
        ref.watch(flowGraphSelectedItemIndexProvider);

    return Padding(
      padding: EdgeInsets.only(
        top: (FlowGraphConstants.frameVerticalPadding +
                FlowGraphConstants.nodeMaxHeight) *
            widget.zoomRate,
      ),
      child: MouseRegion(
        onHover: (event) {
          if (isHoverViewVisible) {
            return;
          }

          // Update the hover position based on the mouse event.
          setState(
            () => hoverPosition = event.localPosition / widget.zoomRate,
          );
        },
        onExit: (_) => setState(() => hoverPosition = null),
        child: OverlayPortal(
          controller: _jsonHoverViewController,
          overlayChildBuilder: (BuildContext context) => Positioned(
            left: (hoverViewPosition.dx * widget.zoomRate) > 400
                ? (hoverViewPosition * widget.zoomRate).dx - 300
                : FlowGraphConstants.frameHorizontalPadding,
            top: (hoverViewPosition.dy * widget.zoomRate) - 20,
            child: MouseRegion(
              onEnter: (_) {
                // Lock the scroll of FlowGraphView when the mouse enters the hover view.
                ref
                    .read(flowGraphScrollLockProvider.notifier)
                    .setLock(isLocked: true);
              },
              onExit: (_) {
                // Unlock the scroll of FlowGraphView when the mouse exits the hover view.
                hoveredData = null;
                isHoverViewVisible = false;
                ref
                    .read(flowGraphScrollLockProvider.notifier)
                    .setLock(isLocked: false);

                // Hide the hover view.
                _jsonHoverViewController.hide();
              },
              child: JsonHoverView(data: hoveredData!),
            ),
          ),
          child: ClipRRect(
            child: CustomPaint(
              size: Size.infinite,
              painter: ItemPainter(
                drawObjects: widget.drawObjects,
                zoomRate: widget.zoomRate,
                hoverPosition: hoverPosition ?? Offset.zero,
                selectedItemIndex: flowGraphSelectedItemIndex,
                onHoveredData: (data) {
                  hoverViewPosition = hoverPosition ?? Offset.zero;

                  // Check if the flow graph is currently scrolling.
                  // If it is, do not show the hover view.
                  final isScrolling = ref.read(flowGraphIsScrollingProvider);
                  if (isScrolling) {
                    return;
                  }

                  hoveredData = data;

                  if (hoveredData != null && isHoverViewVisible == false) {
                    // Show the hover view if there is data to display.
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      isHoverViewVisible = true;

                      _jsonHoverViewController.show();
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// A custom painter to draw items (edges) in the flow graph.
class ItemPainter extends CustomPainter {
  ItemPainter({
    required this.drawObjects,
    required this.hoverPosition,
    required this.onHoveredData,
    required this.zoomRate,
    required this.selectedItemIndex,
  });

  final List<DrawObject>? drawObjects; // List of draw objects to be painted
  final Offset hoverPosition; // Current hover position
  final Function(List<Map<String, dynamic>>)
      onHoveredData; // Callback for hovered data

  List<Map<String, dynamic>>? hoveredData; // Data to be displayed on hover

  // The zoom rate of the flow graph.
  final double zoomRate;

  // The index of the selected item in the flow graph.
  final int selectedItemIndex;

  static Paint borderPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(zoomRate, zoomRate);

    drawItemContents(
      canvas: canvas,
      drawObjects: drawObjects,
      hoverPosition: hoverPosition,
      onHoverData: (data) {
        hoveredData = data;
      },
      selectedItemIndex: selectedItemIndex,
    );

    if (hoveredData != null) {
      onHoveredData(hoveredData!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void drawItemContents({
  required Canvas canvas,
  required List<DrawObject>? drawObjects,
  Offset? hoverPosition,
  Function(List<Map<String, dynamic>>)? onHoverData,
  bool isForCapture = false,
  int? selectedItemIndex,
}) {
  for (final drawObject in drawObjects ?? []) {
    final bool needToDrawBoundary = drawObject.index == selectedItemIndex;

    if (drawObject is NodeEdgeDrawObject) {
      _drawNodeEdgeObjects(
        drawObject,
        canvas,
        hoverPosition,
        onHoverData,
        isForCapture,
        needToDrawBoundary,
      );
    } else if (drawObject is DotLineDrawObject) {
      _drawDotLineObjects(
        drawObject,
        canvas,
        hoverPosition,
        onHoverData,
        isForCapture,
        needToDrawBoundary,
      );
    } else if (drawObject is PointDrawObject) {
      _drawPointObjects(
        drawObject,
        canvas,
        isForCapture,
        needToDrawBoundary,
      );
    }
  }
}

// Draws node edge objects on the canvas.
void _drawNodeEdgeObjects(
  NodeEdgeDrawObject edgeDrawObject,
  Canvas canvas,
  Offset? hoverPosition,
  Function(List<Map<String, dynamic>>)? onHover, [
  isForCapture = false,
  needToDrawBoundary = false,
]) {
  const Color edgeColor = Color(0xFFA3A3A3);
  final paint = Paint()
    ..color = edgeColor
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  final circlePaint = Paint()
    ..color = const Color(0xFFA3A3A3)
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  final borderPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  Rect textArea;

  if (edgeDrawObject.position.start == edgeDrawObject.position.end) {
    final startX = edgeDrawObject.position.start.dx;
    final startY = edgeDrawObject.position.start.dy -
        FlowGraphConstants.eventVerticalGap / 4;

    final Offset rightTopOfLine =
        Offset(startX + FlowGraphConstants.nodeHorizontalGap, startY);
    final Offset rightBottomOfLine = Offset(
      startX + FlowGraphConstants.nodeHorizontalGap,
      startY + FlowGraphConstants.eventVerticalGap / 2,
    );

    final path = Path();
    path.moveTo(startX, startY);
    path.lineTo(rightTopOfLine.dx, rightTopOfLine.dy);
    path.lineTo(
      rightBottomOfLine.dx,
      rightBottomOfLine.dy,
    );
    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(startX, startY),
      6,
      circlePaint,
    );

    _drawArrow(
      start: Offset(
        startX + FlowGraphConstants.nodeHorizontalGap,
        startY + FlowGraphConstants.eventVerticalGap / 2,
      ),
      end: Offset(startX, startY + FlowGraphConstants.eventVerticalGap / 2),
      canvas: canvas,
      color: edgeColor,
    );

    textArea = drawText(
      canvas: canvas,
      x: startX + FlowGraphConstants.nodeHorizontalGap + 20,
      y: startY + FlowGraphConstants.eventVerticalGap / 4,
      text: 'state',
      style: TextStyle(
        color: isForCapture ? Colors.black : Colors.white,
        fontSize: 14,
      ),
    );

    if (needToDrawBoundary) {
      final rect = Rect.fromPoints(
        Offset(startX, startY) - Offset(20, 20),
        rightBottomOfLine + Offset(textArea.width, 0) + Offset(20, 20),
      );
      canvas.drawRect(rect, borderPaint);
    }
  } else {
    final startOffset = Offset(
      edgeDrawObject.position.start.dx,
      edgeDrawObject.position.start.dy,
    );
    final endOffset =
        Offset(edgeDrawObject.position.end.dx, edgeDrawObject.position.end.dy);

    canvas.drawCircle(
      startOffset,
      6,
      circlePaint,
    );

    _drawArrow(
      start: startOffset,
      end: endOffset,
      canvas: canvas,
      color: edgeColor,
    );

    textArea = drawText(
      canvas: canvas,
      x: (startOffset.dx + endOffset.dx) / 2,
      y: startOffset.dy - 10,
      text: 'state',
      style: TextStyle(
        color: isForCapture ? Colors.black : Colors.white,
        fontSize: 14,
      ),
    );

    if (needToDrawBoundary) {
      final rect = Rect.fromPoints(
        startOffset - Offset(20, textArea.height + 20),
        endOffset + Offset(20, 20),
      );
      canvas.drawRect(rect, borderPaint);
    }
  }

  if (hoverPosition != null && textArea.contains(hoverPosition)) {
    onHover?.call(
      List<Map<String, dynamic>>.from(edgeDrawObject.data?.values ?? []),
    );
  }
}

// Draws dot line objects on the canvas.
void _drawDotLineObjects(
  DotLineDrawObject dotLineObject,
  Canvas canvas,
  Offset? hoverPosition,
  Function(List<Map<String, dynamic>>)? onHover, [
  isForCapture = false,
  needToDrawBoundary = false,
]) {
  final paint = Paint()
    ..color = const Color(0xFFA3A3A3)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  final borderPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  drawDashedLine(
    canvas: canvas,
    start: dotLineObject.position.start,
    end: dotLineObject.position.end,
    dashWidth: 5,
    dashSpace: 5,
    paint: paint,
  );

  final textArea = drawText(
    canvas: canvas,
    x: dotLineObject.position.start.dx,
    y: dotLineObject.position.start.dy - 10,
    text: dotLineObject.label,
    style: TextStyle(
      color: isForCapture ? Colors.black : Colors.white,
      fontSize: 12,
    ),
    isCentered: false,
  );

  if (needToDrawBoundary) {
    final rect = Rect.fromPoints(
      dotLineObject.position.start - Offset(20, textArea.height + 20),
      dotLineObject.position.end + Offset(20, 20),
    );
    canvas.drawRect(rect, borderPaint);
  }

  if (hoverPosition != null && textArea.contains(hoverPosition)) {
    onHover?.call([dotLineObject.data ?? {}]);
  }
}

// Draws point objects on the canvas.
void _drawPointObjects(
  PointDrawObject pointObject,
  Canvas canvas, [
  isForCapture = false,
  needToDrawBoundary = false,
]) {
  final paint = Paint()
    ..color = const Color(0xFF404040)
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  final circlePaint = Paint()
    ..color = const Color(0xFFA3A3A3)
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  final borderPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  final textSpan = TextSpan(
    text: pointObject.label,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
  );

  final textPainter = TextPainter()
    ..text = textSpan
    ..textDirection = TextDirection.ltr
    ..textAlign = TextAlign.center
    ..layout();

  final rectArea = Rect.fromLTWH(
    pointObject.offset.dx,
    pointObject.offset.dy - textPainter.height / 2 - 12,
    12 + 12 + 8 + textPainter.width + 12,
    12 + textPainter.height + 12,
  );

  final BorderRadius borderRadius = BorderRadius.circular(8);

  canvas.drawRRect(
    borderRadius.toRRect(rectArea),
    paint,
  );

  final center = Offset(pointObject.offset.dx + 12 + 6, pointObject.offset.dy);
  canvas.drawCircle(center, 6, circlePaint);

  textPainter.paint(
    canvas,
    Offset(
      pointObject.offset.dx + 12 + 12 + 8,
      pointObject.offset.dy - textPainter.height / 2,
    ),
  );

  if (needToDrawBoundary) {
    canvas.drawRect(
      Rect.fromLTWH(
        rectArea.left - 10,
        rectArea.top - 10,
        rectArea.width + 20,
        rectArea.height + 20,
      ),
      borderPaint,
    );
  }
}

// Draws an arrow on the canvas.
void _drawArrow({
  required Offset start,
  required Offset end,
  required Canvas canvas,
  required Color color,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
  const arrowSize = 10;
  const arrowAngle = pi / 6;

  final dX = end.dx - start.dx;
  final dY = end.dy - start.dy;
  final angle = atan2(dY, dX);

  final Offset subtractedB = Offset(
    end.dx - (arrowSize - 2) * cos(angle),
    end.dy - (arrowSize - 2) * sin(angle),
  );

  canvas.drawLine(start, subtractedB, paint);
  final path = Path();

  path.moveTo(
    end.dx - arrowSize * cos(angle - arrowAngle),
    end.dy - arrowSize * sin(angle - arrowAngle),
  );
  path.lineTo(end.dx, end.dy);
  path.lineTo(
    end.dx - arrowSize * cos(angle + arrowAngle),
    end.dy - arrowSize * sin(angle + arrowAngle),
  );
  path.close();
  canvas.drawPath(path, paint);
}
