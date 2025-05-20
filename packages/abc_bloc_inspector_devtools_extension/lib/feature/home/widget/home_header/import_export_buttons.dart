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

// A widget that provides import and export buttons.
class ImportExportButtons extends ConsumerWidget {
  const ImportExportButtons({super.key});

  // Shows a popup dialog with a given message.
  Future<void> _showPopup(
    BuildContext context,
    String message,
    bool isSuccess,
  ) async {
    await showDialog(
      context: context,
      barrierColor: const Color(0xFF171717).withValues(alpha: 0.3),
      builder: (context) => PopupDialog(
        contentWidget: Row(
          children: [
            Image.asset(
              isSuccess
                  ? 'assets/images/check_green.png'
                  : 'assets/images/fail.png',
              height: 20,
              width: 20,
              color:
                  isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFD1D5DB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: [
          // Button for importing data.
          CustomButton(
            iconWidget: const Icon(
              Icons.file_download,
              size: 16,
              color: Colors.white,
            ),
            label: 'Import',
            onTap: () async {
              final result =
                  await ref.read(blocLogProvider.notifier).importBlocLogItems();
              if (context.mounted) {
                final String resultMessage =
                    result ? 'Import is successful' : 'Import is failed';
                await _showPopup(context, resultMessage, result);
              }
            },
          ),
          const SizedBox(width: 16),
          // Button for exporting data.
          CustomButton(
            iconWidget: const Icon(
              Icons.file_upload,
              size: 16,
              color: Colors.white,
            ),
            label: 'Export',
            onTap: () async {
              final result =
                  await ref.read(blocLogProvider.notifier).exportBlocLogItems();
              if (context.mounted) {
                final String resultMessage =
                    result ? 'Export is successful' : 'Export is failed';
                await _showPopup(context, resultMessage, result);
              }
            },
          ),
        ],
      );
}
