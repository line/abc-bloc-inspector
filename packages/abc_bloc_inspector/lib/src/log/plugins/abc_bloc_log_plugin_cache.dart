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

import 'package:abc_bloc_inspector/src/abc_bloc_constants.dart';
import 'package:abc_bloc_inspector/src/log/abc_bloc_log_plugin_base.dart';

// This plugin store logs in memory for later retrieval.
class AbcBlocLogPluginCache extends AbcBlocLogPluginBase {
  factory AbcBlocLogPluginCache({int maxCount = 1000}) {
    _instance ??= AbcBlocLogPluginCache._internal(maxCount);
    return _instance!;
  }

  AbcBlocLogPluginCache._internal(this._maxCount);

  final int _maxCount;

  final List<Map<String, dynamic>> _cache = [];

  static AbcBlocLogPluginCache? _instance;

  @override
  void log(Map<String, dynamic> log) {
    _cache.add(log);

    while (_cache.length > _maxCount) {
      _cache.removeAt(0);
    }
  }

  List<Map<String, dynamic>> get logs => List.unmodifiable(_cache);

  Map<String, dynamic> exportLogs() => {
        'version': AbcBlocConstants.version,
        'logs': _cache,
      };

  void clear() {
    _cache.clear();
  }
}
