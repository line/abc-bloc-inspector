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

// Widget to control zoom in and zoom out functionality
class ControllerWidget extends ConsumerWidget {
  const ControllerWidget({
    super.key,
    required this.onCaptureTap,
    required this.onZoomInTap,
    required this.onZoomOutTap,
  });

  // Callback functions for button taps
  final VoidCallback onCaptureTap;
  final VoidCallback onZoomInTap;
  final VoidCallback onZoomOutTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: <Widget>[
          // Button to capture image
          Center(
            child: CustomButton(
              iconWidget: const Icon(
                Icons.camera,
                color: Colors.white,
              ),
              onTap: onCaptureTap,
            ),
          ),
          const SizedBox(height: 12),
          // Button to increase zoom rate
          Center(
            child: CustomButton(
              iconWidget: const Icon(
                Icons.zoom_in,
                color: Colors.white,
              ),
              onTap: onZoomInTap,
            ),
          ),
          const SizedBox(height: 4),
          // Button to decrease zoom rate
          Center(
            child: CustomButton(
              iconWidget: const Icon(
                Icons.zoom_out,
                color: Colors.white,
              ),
              onTap: onZoomOutTap,
            ),
          ),
        ],
      );
}
