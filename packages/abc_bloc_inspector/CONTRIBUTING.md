# ABC Bloc Inspector

Hi! We're really excited that you're interested in contributing to ABC Bloc Inspector! Before submitting your contribution, please read through the following guide.

## 💻 Local Development

We recommend using Flutter Version 3.27.3+

1. In the Example application folder, install packages first.

   ```bash
   cd packages/abc_bloc_inspector/example
   flutter pub get
   dart run build_runner build watch
   ```

2. Run Example application.

   ```bash
   flutter run
   ```

3. Run DevTools
    ```bash
    dart devtools
    ```

4. Connect Example application with DevTools
   - When you run application(STEP2), you'll see a message in your terminal that looks like the following:
      ```
      A Dart VM Service on iPhone 15 Pro is available at: http://127.0.0.1:62313/7zsaryhHGZ8=/
      The Flutter DevTools debugger and profiler on iPhone 15 Pro is available at:
      http://127.0.0.1:9103?uri=http://127.0.0.1:62313/7zsaryhHGZ8=/
      ```
   - Input that url at 'Connect to a Running App' on DevTools!
  
5. Select `abc_bloc_inspector` tab


## 🌵 How to contribute
### File a issue / Ask a question
- File an issue in [the issue tracker](https://github.com/line/abc-bloc-inspector/issues)
  to report bugs and propose new features and improvements.

- Ask a question using [the issue tracker](https://github.com/line/abc-bloc-inspector/issues).

### Pull Request Guidelines

- Checkout a topic branch from a base branch `main`, and merge back against that branch.
- Run the command below to see if there are no errors or if there is an increase in the number of unsuspecting warnings!
  ```sh
  flutter analyze
  ````
- If adding a new feature:

  - Provide a convincing reason to add this feature. Ideally, you should open a suggestion issue first, and have it approved before working on it.

- If fixing a bug:

  - If you are resolving a special issue, add `fix #issueId` in your PR title.
  - Provide a detailed description of the bug and how you fix it in the PR.
- Contribute your work by sending [a pull request](https://github.com/line/abc-bloc-inspector/pulls).
