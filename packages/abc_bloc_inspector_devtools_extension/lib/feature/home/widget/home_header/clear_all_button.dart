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

// A button widget that clears all items when tapped.
class ClearAllButton extends StatelessWidget {
  const ClearAllButton({
    super.key,
    required this.onTap,
  });

  // Callback function to be called when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => CustomButton(
        iconWidget: const Icon(
          Icons.delete_outline,
          size: 16,
          color: Colors.white,
        ),
        label: 'Clear All',
        onTap: onTap,
      );
}
