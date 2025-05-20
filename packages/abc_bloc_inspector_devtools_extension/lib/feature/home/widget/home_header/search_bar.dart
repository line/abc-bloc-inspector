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

// A widget that provides a search bar.
class SearchBar extends ConsumerWidget {
  const SearchBar({
    super.key,
    this.onSearchWordChanged,
  });

  // Callback function to be called when the search word changes.
  final void Function(String)? onSearchWordChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controller for the search text field.
    final TextEditingController controller = TextEditingController();
    // Watch the current search word from the provider.
    final searchWord = ref.watch(searchProvider);

    // Set the controller's text to the current search word.
    controller.text = searchWord;
    // Set the cursor position to the end of the text.
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Container(
      height: 40,
      width: 290,
      decoration: BoxDecoration(
        color: const Color(0xFF404040),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white, // Set the text color
        ),
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Color(0xFFADAEBC),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFFD4D4D4),
          ),
          border: InputBorder.none,
        ),
        // Call the callback function when the search word changes.
        onChanged: onSearchWordChanged,
      ),
    );
  }
}
