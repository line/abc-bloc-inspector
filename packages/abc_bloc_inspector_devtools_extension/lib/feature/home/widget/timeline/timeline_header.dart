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

part of 'timeline_view.dart';

class TimelineHeader extends StatelessWidget {
  const TimelineHeader({
    super.key,
    required this.flexItems,
    required this.isSingleBloc,
    required this.isStateChangeable,
  });

  final List<int> flexItems;
  final bool isSingleBloc;
  final bool isStateChangeable;

  static TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF404040),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: flexItems[0],
              child: Row(
                children: [
                  Image.asset('assets/images/clock.png', width: 14, height: 14),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      'Timestamp',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            if (!isSingleBloc) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: flexItems[1],
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/cube.png',
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        'Bloc',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(width: 8),
            Expanded(
              flex: flexItems[2],
              child: Row(
                children: [
                  Image.asset('assets/images/type.png', width: 14, height: 14),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      'Type',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: flexItems[3],
              child: Row(
                children: [
                  Image.asset('assets/images/bolt.png', width: 14, height: 14),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      'EventName',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: flexItems[4],
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/circle.png',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      'CurrentState',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: flexItems[5],
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/circle.png',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      'NextState',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            if (isStateChangeable) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: flexItems[6],
                child: const SizedBox(),
              ),
            ],
          ],
        ),
      );
}
