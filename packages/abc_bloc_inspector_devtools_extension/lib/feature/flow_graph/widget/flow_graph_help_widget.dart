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

class FlowGraphHelpWidget extends StatelessWidget {
  const FlowGraphHelpWidget({super.key});

  @override
  Widget build(BuildContext context) => HelpButton(
        onTap: () {
          unawaited(
            showDialog(
              context: context,
              builder: (context) => PopupDialog(
                titleWidget: const Text(
                  'Graph View Usage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                contentWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/drag_cursor.png',
                          height: 20,
                        ),
                        Text(
                          ' (Click and Drag) : Navigator the graph',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/hover_cursor.png',
                          height: 20,
                        ),
                        Text(
                          ' (Hover) : Show item details on instant view',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
