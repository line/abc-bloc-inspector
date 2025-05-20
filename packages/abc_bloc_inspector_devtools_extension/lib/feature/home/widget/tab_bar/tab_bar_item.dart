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

part of 'tab_bar.dart';

// A widget representing a single tab item in the custom tab bar.
class TabBarItem extends ConsumerWidget {
  const TabBarItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  // Indicates whether the tab is selected.
  final bool isSelected;

  // The label of the tab.
  final String label;

  // Callback function to be called when the tab is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color:
                isSelected ? const Color(0xFF525252) : const Color(0xFF262626),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : const Color(0xFFD4D4D4),
            ),
          ),
        ),
      );
}
