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

part of 'home_header.dart';

// A widget that provides a mode selector with 'Single' and 'Multi' options.
class ModeSelector extends ConsumerWidget {
  const ModeSelector({
    super.key,
    required this.onModeChanged,
  });

  // Callback function to be called when the mode changes.
  final void Function(ModeType) onModeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current selected mode from the provider.
    final selectedMode = ref.watch(modeProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Color(0xFF404040),
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Mode',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            width: 200,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF404040),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Button for 'Single' mode.
                _ModeButton(
                  label: 'Single',
                  isSelected: selectedMode == ModeType.single,
                  onTap: () {
                    onModeChanged(ModeType.single);
                  },
                ),
                const SizedBox(width: 4),
                // Button for 'Multi' mode.
                _ModeButton(
                  label: 'Multi',
                  isSelected: selectedMode == ModeType.multi,
                  onTap: () {
                    onModeChanged(ModeType.multi);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A button widget used within the ModeSelector to represent a mode option.
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  // The label of the button.
  final String label;

  // Whether the button is currently selected.
  final bool isSelected;

  // Callback function to be called when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 94, 93, 93)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      );
}
