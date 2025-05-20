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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bloc_list_changed.g.dart';

@riverpod
class BlocListChanged extends _$BlocListChanged {
  @override
  Stream<void> build() async* {
    final service = ref.watch(serviceProvider);

    yield* service.onExtensionEvent.where(
      (event) => event.extensionKind == AbcBlocConstants.blocListChanged,
    );
  }
}
