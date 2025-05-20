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
import 'package:abc_bloc_inspector_devtools_extension/common/provider/bloc_list_changed.dart';
import 'package:abc_bloc_inspector_devtools_extension/common/provider/extension/library_eval.dart';
import 'package:devtools_app_shared/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vm_service/vm_service.dart';

part 'active_blocs.g.dart';

@riverpod
class ActiveBlocs extends _$ActiveBlocs {
  @override
  Future<List<String>> build() async {
    ref.watch(blocListChangedProvider);

    final isAlive = Disposable();
    ref.onDispose(isAlive.dispose);

    // ignore: avoid_manual_providers_as_generated_provider_dependency
    // TODO: Need to resolve this warning
    final eval = await ref.watch(blocBindingEvalProvider.future);

    final blocListRefs = await eval.evalInstance(
      AbcBlocConstants.blocBindingBlocKeys,
      isAlive: isAlive,
    );

    final blocListInstances = await Future.wait([
      for (final idRef in blocListRefs.elements!.cast<InstanceRef>()) eval.safeGetInstance(idRef, isAlive),
    ]);

    return [
      for (final idInstance in blocListInstances) idInstance.valueAsString!,
    ];
  }
}
