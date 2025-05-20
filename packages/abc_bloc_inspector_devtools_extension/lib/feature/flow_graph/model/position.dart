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

import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

// A class representing a position with a start and end offset.
@freezed
sealed class Position with _$Position {
  // Factory constructor to create a Position instance.
  factory Position({
    // The start offset of the position.
    @_PointConverter() required Offset start,

    // The end offset of the position.
    @_PointConverter() required Offset end,
  }) = _Position;

  // Factory constructor to create a Position instance from JSON.
  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
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

// Extension on the Position class to add scaling functionality.
extension PositionExtension on Position {
  // Scales the start and end offsets of the position by the given factors.
  Position scale(double scaleStart, double scaleEnd) => Position(
        start: Offset(start.dx * scaleStart, start.dy * scaleStart),
        end: Offset(start.dx * scaleEnd, end.dy * scaleEnd),
      );
}
