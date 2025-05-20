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

import 'package:abc_bloc_inspector_devtools_extension/feature/flow_graph/model/position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'draw_object.freezed.dart';
part 'draw_object.g.dart';

// A sealed class representing different types of drawable objects in the flow graph.
@freezed
sealed class DrawObject with _$DrawObject {
  // A factory constructor for creating a node draw object.
  factory DrawObject.node({
    required String blocName,
    required String label,
    required Position nodePosition,
    required Position nodeLinePosition,
    Map<String, dynamic>? data,
  }) = NodeDrawObject;

  // A factory constructor for creating a node edge draw object.
  factory DrawObject.nodeEdge({
    required int index,
    required Position position,
    Map<String, dynamic>? data,
  }) = NodeEdgeDrawObject;

  // A factory constructor for creating a point draw object.
  factory DrawObject.point({
    required int index,
    required String label,
    @_PointConverter() required Offset offset,
    Map<String, dynamic>? data,
  }) = PointDrawObject;

  // A factory constructor for creating a dot line draw object.
  factory DrawObject.dotLine({
    required int index,
    required String label,
    required Position position,
    Map<String, dynamic>? data,
  }) = DotLineDrawObject;

  // A factory constructor for creating a DrawObject instance from JSON.
  factory DrawObject.fromJson(Map<String, dynamic> json) =>
      _$DrawObjectFromJson(json);
}

extension DrawObjectX on DrawObject {
  int getIndex() => switch (this) {
        NodeEdgeDrawObject() => (this as NodeEdgeDrawObject).index,
        PointDrawObject() => (this as PointDrawObject).index,
        DotLineDrawObject() => (this as DotLineDrawObject).index,
        NodeDrawObject() => -1
      };
}

// A custom JSON converter for Offset.
class _PointConverter extends JsonConverter<Offset, Map<String, dynamic>> {
  const _PointConverter();

  // Converts JSON to Offset.
  @override
  Offset fromJson(Map<String, dynamic> json) =>
      Offset(json['dx'] as double, json['dy'] as double);

  // Converts Offset to JSON.
  @override
  Map<String, dynamic> toJson(Offset object) => {
        'x': object.dx,
        'y': object.dy,
      };
}
