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

import 'package:abc_bloc_inspector/abc_bloc_inspector.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/provider/extension/service.dart';
import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_eval.g.dart';

final blocBindingEvalProvider = libraryEvalProvider(AbcBlocConstants.blocBindingPath);

@riverpod
class LibraryEval extends _$LibraryEval {
  @override
  Future<EvalOnDartLibrary> build(String libraryPath) async {
    final service = ref.watch(serviceProvider);

    final eval = EvalOnDartLibrary(
      libraryPath,
      service,
      serviceManager: serviceManager,
    );
    ref.onDispose(eval.dispose);
    return eval;
  }
}
