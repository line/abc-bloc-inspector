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

// Compares two maps and returns the differences between them.
//
// The differences are represented as a map where the keys are the paths to the differing values
// and the values are maps with 'from' and 'to' keys indicating the values in mapA and mapB respectively.
Map<String, dynamic> getDifferences(
  Map mapA,
  Map mapB, [
  String parentKey = '',
]) {
  final Map<String, dynamic> differences = {};

  // Iterate through each key in mapA.
  for (final key
      in mapA.keys.length > mapB.keys.length ? mapA.keys : mapB.keys) {
    final String fullKey = parentKey.isEmpty ? key : '$parentKey.$key';

    // If mapB does not contain the key, add it to differences with 'to' as null.
    if (!mapB.containsKey(key)) {
      differences[fullKey] = {'from': mapA[key], 'to': null};
    }
    // If both values are maps, recursively find differences.
    else if (mapA[key] is Map && mapB[key] is Map) {
      differences.addAll(getDifferences(mapA[key], mapB[key], fullKey));
    }
    // If both values are lists, compare each element.
    else if (mapA[key] is List && mapB[key] is List) {
      final maxLength = mapA[key].length > mapB[key].length
          ? mapA[key].length
          : mapB[key].length;
      for (var i = 0; i < maxLength; i++) {
        if (mapA[key].length <= i) {
          differences['$fullKey[$i]'] = {'from': null, 'to': mapB[key][i]};
        } else if (mapB[key].length <= i) {
          differences['$fullKey[$i]'] = {'from': mapA[key][i], 'to': null};
        } else if (mapA[key][i] is Map && mapB[key][i] is Map) {
          differences.addAll(
            getDifferences(mapA[key][i], mapB[key][i], '$fullKey[$i]'),
          );
        } else if (mapA[key][i] != mapB[key][i]) {
          differences['$fullKey[$i]'] = {
            'from': mapA[key][i],
            'to': mapB[key][i],
          };
        }
      }
    }
    // If the values are different, add them to differences.
    else if (mapA[key] != mapB[key]) {
      differences[fullKey] = {'from': mapA[key], 'to': mapB[key]};
    }
  }

  return differences;
}
